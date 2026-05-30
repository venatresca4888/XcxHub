local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local MAX_NOTIFICATIONS = 3

local Gui = CoreGui:FindFirstChild("NotificationGui")

if not Gui then
	Gui = Instance.new("ScreenGui")
	Gui.Name = "NotificationGui"
	Gui.ResetOnSpawn = false
	Gui.DisplayOrder = 999999
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Gui.Parent = CoreGui

	local Holder = Instance.new("Frame")
	Holder.Name = "Holder"
	Holder.Parent = Gui
	Holder.BackgroundTransparency = 1
	Holder.AnchorPoint = Vector2.new(1,0)
	Holder.Position = UDim2.new(1,-20,0,20)
	Holder.Size = UDim2.new(0,280,1,0)

	local Layout = Instance.new("UIListLayout")
	Layout.Parent = Holder
	Layout.Padding = UDim.new(0,10)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
end

local Holder = Gui.Holder

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

	local Frame = Instance.new("Frame")
	Frame.Parent = Holder
	Frame.Size = UDim2.new(0,260,0,75)
	Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 5)
	Corner.Parent = Frame

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Frame
	Stroke.Thickness = 1
	Stroke.Color = Color3.fromRGB(90,90,90)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = Frame
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0,8,0,4)
	TitleLabel.Size = UDim2.new(1,-16,0,22)
	TitleLabel.Font = Enum.Font.SourceSansBold
	TitleLabel.TextSize = 21
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextColor3 = Color3.new(1,1,1)
	TitleLabel.Text = tostring(Title)

	local Line = Instance.new("Frame")
	Line.Parent = Frame
	Line.Size = UDim2.new(1,0,0,2)
	Line.Position = UDim2.new(0,0,0,28)
	Line.BorderSizePixel = 0
	Line.BackgroundColor3 = Color3.fromRGB(70,70,70)

	local MessageLabel = Instance.new("TextLabel")
	MessageLabel.Parent = Frame
	MessageLabel.BackgroundTransparency = 1
	MessageLabel.Position = UDim2.new(0,8,0,34)
	MessageLabel.Size = UDim2.new(1,-16,0,28)
	MessageLabel.Font = Enum.Font.SourceSans
	MessageLabel.TextSize = 18
	MessageLabel.TextWrapped = true
	MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
	MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
	MessageLabel.TextColor3 = Color3.new(1,1,1)
	MessageLabel.Text = tostring(Message)

	local ProgressBG = Instance.new("Frame")
	ProgressBG.Parent = Frame
	ProgressBG.Size = UDim2.new(1,0,0,3)
	ProgressBG.Position = UDim2.new(0,0,1,-3)
	ProgressBG.BorderSizePixel = 0
	ProgressBG.BackgroundColor3 = Color3.fromRGB(25,25,25)

	local Progress = Instance.new("Frame")
	Progress.Parent = ProgressBG
	Progress.Size = UDim2.new(1,0,1,0)
	Progress.BorderSizePixel = 0
	Progress.BackgroundColor3 = Color3.fromRGB(0,170,255)

	local ProgressCorner = Instance.new("UICorner")
	ProgressCorner.Parent = Progress

	Frame.BackgroundTransparency = 1
	TitleLabel.TextTransparency = 1
	MessageLabel.TextTransparency = 1
	Line.BackgroundTransparency = 1

	local FinalSize = Frame.Size
	Frame.Size = UDim2.new(0,0,0,75)

	TweenService:Create(
		Frame,
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
		TitleLabel,
		TweenInfo.new(0.25),
		{
			TextTransparency = 0
		}
	):Play()

	TweenService:Create(
		MessageLabel,
		TweenInfo.new(0.25),
		{
			TextTransparency = 0
		}
	):Play()

	TweenService:Create(
		Line,
		TweenInfo.new(0.25),
		{
			BackgroundTransparency = 0
		}
	):Play()

	TweenService:Create(
		Progress,
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
			Frame,
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
			TitleLabel,
			TweenInfo.new(0.2),
			{
				TextTransparency = 1
			}
		):Play()

		TweenService:Create(
			MessageLabel,
			TweenInfo.new(0.2),
			{
				TextTransparency = 1
			}
		):Play()

		task.wait(0.3)

		if Frame and Frame.Parent then
			Frame:Destroy()
		end
	end)
end

return Notify
