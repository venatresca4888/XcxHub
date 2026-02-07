getgenv().Config = {
    WebhookEnabled = true,
    WebhookURL = "webhook_url_here",
    SafeMode = true,
    TweenSpeed = 300,
    DelayTime = 0.5,
    AutoServerHop = true,
    AutoRejoin = true
}

-- [[ 🛠️ Services ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- [[ 🔒 Hardcoded Targets ]] --
local TargetList = {"Chest1", "Chest2"} 

local SendWebhook = loadstring(game:HttpGet('https://raw.githubusercontent.com/GGXD99/XcxHub/refs/heads/main/Webhook'))()

-- [[ 🔔 Notification Helper ]] --
local function Notify(text)
    StarterGui:SetCore("SendNotification", {Title = "XcxHub", Text = text, Duration = 3})
end

-- [[ 🔄 Auto Rejoin ]] --
if getgenv().Config.AutoRejoin then
    spawn(function()
        local prompt = CoreGui:WaitForChild("RobloxPromptGui")
        local overlay = prompt:WaitForChild("promptOverlay")
        overlay.ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" then
                SendWebhook("Disconnected", "Rejoining in 2s...", 0xFF0000)
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end)
end

-- [[ 🚀 Server Hop ]] --
local function ServerHop()
    Notify("Chest Empty! Hopping Server...")
    SendStatusWebhook("Server Hop", "Searching for new server...", 0xFFFF00)
    task.wait(1)
    
    local PlaceId = game.PlaceId
    local Cursor = ""
    local FoundServer = false
    
    while not FoundServer do
        local Url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        if Cursor ~= "" then Url = Url .. "&cursor=" .. Cursor end
        
        local Success, Result = pcall(function() return HttpService:JSONDecode(game:HttpGet(Url)) end)
        
        if Success and Result and Result.data then
            for _, Server in ipairs(Result.data) do
                if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                    FoundServer = true
                    TeleportService:TeleportToPlaceInstance(PlaceId, Server.id, LocalPlayer)
                    return
                end
            end
            Cursor = Result.nextPageCursor or ""
        else
            task.wait(1)
        end
    end
end

-- [[ 🚶 Movement Logic ]] --
local function MoveToTarget(TargetPart)
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    
    if getgenv().Config.SafeMode then
        local Distance = (Root.Position - TargetPart.Position).Magnitude
        local Time = Distance / getgenv().Config.TweenSpeed
        local Tween = TweenService:Create(Root, TweenInfoData or TweenInfo.new(Time, Enum.EasingStyle.Linear), {CFrame = TargetPart.CFrame})
        
        local BV = Instance.new("BodyVelocity", Root)
        BV.Velocity = Vector3.new(0,0,0); BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local Noclip = RunService.Stepped:Connect(function()
            for _, v in pairs(Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end)
        
        Tween:Play()
        Tween.Completed:Wait()
        if Noclip then Noclip:Disconnect() end
        if BV then BV:Destroy() end
    else
        Root.CFrame = TargetPart.CFrame
        Root.Velocity = Vector3.new(0,0,0)
    end
end

-- [[ 📦 Main Logic ]] --
task.spawn(function()
    -- เรียกใช้ Webhook จาก Module
    SendWebhook("Script Started", "XcxHub Chest Farm initialized.", 0x0000FF)
    
    while task.wait(1) do
        local Character = LocalPlayer.Character
        if not Character then continue end
        
        local FoundChests = {}
        for _, Obj in pairs(workspace:GetDescendants()) do
            if (Obj:IsA("Part") or Obj:IsA("MeshPart")) and table.find(TargetList, Obj.Name) then
                if Obj:FindFirstChild("TouchInterest") then
                    table.insert(FoundChests, Obj)
                end
            end
        end
        
        if #FoundChests == 0 then
            if getgenv().Config.AutoServerHop then
                ServerHop()
            else
                Notify("No chests found. Idle...")
                break
            end
        else
            Notify("Found " .. #FoundChests .. " chests.")
            -- แจ้งเตือนสถานะการฟาร์ม
            SendWebhook("Farming", "Found " .. #FoundChests .. " chests. Collecting...", 0x00FF00)
        end
        
        for _, Chest in ipairs(FoundChests) do
            if Chest.Parent and Chest:FindFirstChild("TouchInterest") then
                MoveToTarget(Chest)
                task.wait(getgenv().Config.DelayTime)
            end
        end
    end
end)