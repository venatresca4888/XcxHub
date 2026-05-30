local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local MAX_NOTIFICATIONS = 3

local NotificationGui = CoreGui:FindFirstChild("NotificationGui")

if not NotificationGui then
	NotificationGui = Instance.new("ScreenGui")
	NotificationGui.Name = "NotificationGui"
	NotificationGui.ResetOnSpawn = false
	NotificationGui.DisplayOrder = 999999
	NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	NotificationGui.Parent = CoreGui

	local NotificationHolder = Instance.new("Frame")
	NotificationHolder.Name = "Holder"
	NotificationHolder.Parent = NotificationGui
	NotificationHolder.BackgroundTransparency = 1
	NotificationHolder.AnchorPoint = Vector2.new(1,0)
	NotificationHolder.Position = UDim2.new(1,-20,0,20)
	NotificationHolder.Size = UDim2.new(0,280,1,0)

	local NotificationLayout = Instance.new("UIListLayout")
	NotificationLayout.Parent = NotificationHolder
	NotificationLayout.Padding = UDim.new(0,10)
	NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
end

local Holder = NotificationGui.Holder

local function GetNotifications()
	local Notifications = {}

	for _,v in ipairs(Holder:GetChildren()) do
		if v:IsA("Frame") then
			table.insert(Notifications, v)
		end
	end

	return Notifications
end

local function Notify(Title, Message, Duration)
	Duration = Duration or 5

	local Notifications = GetNotifications()

	if #Notifications >= MAX_NOTIFICATIONS then
		Notifications[1]:Destroy()
	end

	local NotificationFrame = Instance.new("Frame")
	NotificationFrame.Parent = Holder
	NotificationFrame.Size = UDim2.new(0,260,0,75)
	NotificationFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	NotificationFrame.BorderSizePixel = 0
	NotificationFrame.ClipsDescendants = true

	local NotificationCorner = Instance.new("UICorner")
	NotificationCorner.CornerRadius = UDim.new(0, 5)
	NotificationCorner.Parent = NotificationFrame

	local NotificationStroke = Instance.new("UIStroke")
	NotificationStroke.Parent = NotificationFrame
	NotificationStroke.Thickness = 1
	NotificationStroke.Color = Color3.fromRGB(90,90,90)

	local NotificationTitle = Instance.new("TextLabel")
	NotificationTitle.Parent = NotificationFrame
	NotificationTitle.BackgroundTransparency = 1
	NotificationTitle.Position = UDim2.new(0,8,0,4)
	NotificationTitle.Size = UDim2.new(1,-16,0,22)
	NotificationTitle.Font = Enum.Font.SourceSansBold
	NotificationTitle.TextSize = 21
	NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
	NotificationTitle.TextColor3 = Color3.new(1,1,1)
	NotificationTitle.Text = tostring(Title)

	local NotificationLine = Instance.new("Frame")
	NotificationLine.Parent = NotificationFrame
	NotificationLine.Size = UDim2.new(1,0,0,2)
	NotificationLine.Position = UDim2.new(0,0,0,28)
	NotificationLine.BorderSizePixel = 0
	NotificationLine.BackgroundColor3 = Color3.fromRGB(70,70,70)

	local NotificationLabel = Instance.new("TextLabel")
	NotificationLabel.Parent = NotificationFrame
	NotificationLabel.BackgroundTransparency = 1
	NotificationLabel.Position = UDim2.new(0,8,0,34)
	NotificationLabel.Size = UDim2.new(1,-16,0,28)
	NotificationLabel.Font = Enum.Font.SourceSans
	NotificationLabel.TextSize = 18
	NotificationLabel.TextWrapped = true
	NotificationLabel.TextXAlignment = Enum.TextXAlignment.Left
	NotificationLabel.TextYAlignment = Enum.TextYAlignment.Top
	NotificationLabel.TextColor3 = Color3.new(1,1,1)
	NotificationLabel.Text = tostring(Message)

	local NotificationProgressBG = Instance.new("Frame")
	NotificationProgressBG.Parent = NotificationFrame
	NotificationProgressBG.Size = UDim2.new(1,0,0,3)
	NotificationProgressBG.Position = UDim2.new(0,0,1,-3)
	NotificationProgressBG.BorderSizePixel = 0
	NotificationProgressBG.BackgroundColor3 = Color3.fromRGB(25,25,25)

	local NotificationProgress = Instance.new("Frame")
	NotificationProgress.Parent = NotificationProgressBG
	NotificationProgress.Size = UDim2.new(1,0,1,0)
	NotificationProgress.BorderSizePixel = 0
	NotificationProgress.BackgroundColor3 = Color3.fromRGB(0,170,255)

	local NotificationProgressCorner = Instance.new("UICorner")
	NotificationProgressCorner.Parent = NotificationProgress

	NotificationFrame.BackgroundTransparency = 1
	NotificationTitle.TextTransparency = 1
	NotificationLabel.TextTransparency = 1
	NotificationLine.BackgroundTransparency = 1

	local FinalSize = NotificationFrame.Size
	NotificationFrame.Size = UDim2.new(0,0,0,75)

	TweenService:Create(
		NotificationFrame,
		TweenInfo.new(
			0.35,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),
		{
			Size = FinalSize,
			BackgroundTransparency = 0
		}
	):Play()

	TweenService:Create(
		NotificationTitle,
		TweenInfo.new(0.25),
		{
			TextTransparency = 0
		}
	):Play()

	TweenService:Create(
		NotificationLabel,
		TweenInfo.new(0.25),
		{
			TextTransparency = 0
		}
	):Play()

	TweenService:Create(
		NotificationLine,
		TweenInfo.new(0.25),
		{
			BackgroundTransparency = 0
		}
	):Play()

	TweenService:Create(
		NotificationProgress,
		TweenInfo.new(
			Duration,
			Enum.EasingStyle.Linear
		),
		{
			Size = UDim2.new(0,0,1,0)
		}
	):Play()

	task.spawn(function()
		task.wait(Duration)

		TweenService:Create(
			NotificationFrame,
			TweenInfo.new(
				0.25,
				Enum.EasingStyle.Quart,
				Enum.EasingDirection.In
			),
			{
				Size = UDim2.new(0,0,0,75),
				BackgroundTransparency = 1
			}
		):Play()

		TweenService:Create(
			NotificationTitle,
			TweenInfo.new(0.2),
			{
				TextTransparency = 1
			}
		):Play()

		TweenService:Create(
			NotificationLabel,
			TweenInfo.new(0.2),
			{
				TextTransparency = 1
			}
		):Play()

		task.wait(0.3)

		if NotificationFrame and NotificationFrame.Parent then
			NotificationFrame:Destroy()
		end
	end)
end

return Notify
