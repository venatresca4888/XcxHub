local NotificationGui = Instance.new("ScreenGui")
local NotificationFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local NotificationHeadFrame = Instance.new("Frame")
local NotificationTitle = Instance.new("TextLabel")
local NotificationTextBox = Instance.new("TextBox")

if game:GetService("CoreGui"):FindFirstChild("NotificationGui") then
	game:GetService("CoreGui").NotificationGui:Destroy()
end

NotificationGui.Name = "NotificationGui"
NotificationGui.Parent = game:GetService"CoreGui"
NotificationGui.DisplayOrder = 999999 
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
NotificationGui.ResetOnSpawn = false

NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = NotificationGui
NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NotificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Position = UDim2.new(0.834279239, 0, 0.153076932, 0)
NotificationFrame.Size = UDim2.new(0, 260, 0, 69)

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = NotificationFrame

NotificationHeadFrame.Name = "NotificationHeadFrame"
NotificationHeadFrame.Parent = NotificationFrame
NotificationHeadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
NotificationHeadFrame.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
NotificationHeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationHeadFrame.BorderSizePixel = 0
NotificationHeadFrame.Position = UDim2.new(0.5, 0, 0.387681037, 0)
NotificationHeadFrame.Size = UDim2.new(0, 260, 0, 2)

NotificationTitle.Name = "NotificationTitle"
NotificationTitle.Parent = NotificationFrame
NotificationTitle.AnchorPoint = Vector2.new(0.5, 0.5)
NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.BackgroundTransparency = 1.000
NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationTitle.BorderSizePixel = 0
NotificationTitle.Position = UDim2.new(0.5, 0, 0.211050496, 0)
NotificationTitle.Size = UDim2.new(0, 200, 0, 26)
NotificationTitle.Font = Enum.Font.SourceSansBold
NotificationTitle.Text = "Xcx Manager"
NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.TextSize = 21.000
NotificationTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

NotificationTextBox.Name = "NotificationTextBox"
NotificationTextBox.Parent = NotificationFrame
NotificationTextBox.AnchorPoint = Vector2.new(0.5, 0.5)
NotificationTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationTextBox.BackgroundTransparency = 1.000
NotificationTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationTextBox.BorderSizePixel = 0
NotificationTextBox.Position = UDim2.new(0.5, 0, 0.695652187, 0)
NotificationTextBox.Size = UDim2.new(0, 248, 0, 41)
NotificationTextBox.Font = Enum.Font.SourceSans
NotificationTextBox.Text = ""
NotificationTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationTextBox.TextSize = 20.000
NotificationTextBox.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
NotificationTextBox.TextXAlignment = Enum.TextXAlignment.Left
NotificationTextBox.TextYAlignment = Enum.TextYAlignment.Top

local TweenService = game:GetService("TweenService")

-- ตำแหน่งสุดท้าย
local EndPos = UDim2.new(0.834279239, 0, 0.153076932, 0)

-- เริ่มนอกจอทางขวา
NotificationFrame.Position = UDim2.new(1.2, 0, EndPos.Y.Scale, 0)

-- ซ่อนตอนเริ่ม
NotificationFrame.BackgroundTransparency = 1
NotificationTitle.TextTransparency = 1
NotificationTextBox.TextTransparency = 1
NotificationHeadFrame.BackgroundTransparency = 1

-- Tween เข้า
local ShowTween = TweenService:Create(
	NotificationFrame,
	TweenInfo.new(
		0.6,
		Enum.EasingStyle.Quart,
		Enum.EasingDirection.Out
	),
	{
		Position = EndPos,
		BackgroundTransparency = 0
	}
)

local FadeInTitle = TweenService:Create(
	NotificationTitle,
	TweenInfo.new(0.5),
	{
		TextTransparency = 0
	}
)

local FadeInText = TweenService:Create(
	NotificationTextBox,
	TweenInfo.new(0.5),
	{
		TextTransparency = 0
	}
)

local FadeInLine = TweenService:Create(
	NotificationHeadFrame,
	TweenInfo.new(0.5),
	{
		BackgroundTransparency = 0
	}
)

ShowTween:Play()
FadeInTitle:Play()
FadeInText:Play()
FadeInLine:Play()

-- แสดง 5 วินาที
task.wait(5)

-- Tween ออก
local HideTween = TweenService:Create(
	NotificationFrame,
	TweenInfo.new(
		0.5,
		Enum.EasingStyle.Quart,
		Enum.EasingDirection.In
	),
	{
		Position = UDim2.new(1.2, 0, EndPos.Y.Scale, 0),
		BackgroundTransparency = 1
	}
)

local FadeOutTitle = TweenService:Create(
	NotificationTitle,
	TweenInfo.new(0.4),
	{
		TextTransparency = 1
	}
)

local FadeOutText = TweenService:Create(
	NotificationTextBox,
	TweenInfo.new(0.4),
	{
		TextTransparency = 1
	}
)

local FadeOutLine = TweenService:Create(
	NotificationHeadFrame,
	TweenInfo.new(0.4),
	{
		BackgroundTransparency = 1
	}
)

HideTween:Play()
FadeOutTitle:Play()
FadeOutText:Play()
FadeOutLine:Play()

HideTween.Completed:Wait()
NotificationGui:Destroy()
