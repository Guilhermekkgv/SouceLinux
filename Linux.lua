local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Linux = {}
Linux.__index = Linux

local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quart)

function Linux.Create(config)
    local GUI = {}
    setmetatable(GUI, Linux)
    
    GUI.ScreenGui = Instance.new("ScreenGui")
    GUI.ScreenGui.Name = config.Name
    GUI.ScreenGui.ResetOnSpawn = false
    GUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    GUI.MainFrame = Instance.new("Frame")
    GUI.MainFrame.Name = "MainFrame"
    GUI.MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    GUI.MainFrame.BorderSizePixel = 0
    GUI.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    GUI.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    GUI.MainFrame.Size = UserInputService.TouchEnabled and UDim2.new(0, 330, 0, 250) or UDim2.new(0, 450, 0, 280)
    GUI.MainFrame.Parent = GUI.ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = GUI.MainFrame
    
    GUI.TopBar = Instance.new("Frame")
    GUI.TopBar.Name = "TopBar"
    GUI.TopBar.Size = UDim2.new(1, 0, 0, 30)
    GUI.TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    GUI.TopBar.BorderSizePixel = 0
    GUI.TopBar.Parent = GUI.MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 6)
    TopCorner.Parent = GUI.TopBar
    
    GUI.Title = Instance.new("TextLabel")
    GUI.Title.Name = "Title"
    GUI.Title.Size = UDim2.new(1, -20, 1, 0)
    GUI.Title.Position = UDim2.new(0, 10, 0, 0)
    GUI.Title.BackgroundTransparency = 1
    GUI.Title.Text = config.Name
    GUI.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    GUI.Title.TextSize = 14
    GUI.Title.Font = Enum.Font.GothamBold
    GUI.Title.TextXAlignment = Enum.TextXAlignment.Left
    GUI.Title.Parent = GUI.TopBar
    
    GUI.TabHolder = Instance.new("Frame")
    GUI.TabHolder.Name = "TabHolder"
    GUI.TabHolder.Size = UDim2.new(0, 100, 1, -35)
    GUI.TabHolder.Position = UDim2.new(0, 0, 0, 35)
    GUI.TabHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    GUI.TabHolder.BorderSizePixel = 0
    GUI.TabHolder.Parent = GUI.MainFrame
    
    GUI.TabContainer = Instance.new("ScrollingFrame")
    GUI.TabContainer.Name = "TabContainer"
    GUI.TabContainer.Size = UDim2.new(1, 0, 1, 0)
    GUI.TabContainer.BackgroundTransparency = 1
    GUI.TabContainer.ScrollBarThickness = 0
    GUI.TabContainer.Parent = GUI.TabHolder
    
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = GUI.TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = GUI.TabContainer
    TabPadding.PaddingTop = UDim.new(0, 5)
    
    GUI.ContentContainer = Instance.new("Frame")
    GUI.ContentContainer.Name = "ContentContainer"
    GUI.ContentContainer.Size = UDim2.new(1, -105, 1, -35)
    GUI.ContentContainer.Position = UDim2.new(0, 105, 0, 35)
    GUI.ContentContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    GUI.ContentContainer.BorderSizePixel = 0
    GUI.ContentContainer.Parent = GUI.MainFrame
    
    GUI.Tabs = {}
    GUI.ActiveTab = nil

    function GUI:CreateElement(elementType, container)
        local Element = Instance.new("Frame")
        Element.Size = UDim2.new(1, 0, 0, 32)
        Element.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        Element.BorderSizePixel = 0
        Element.Parent = container

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = Element

        return Element
    end

    function GUI:Tab(tabConfig)
        local Tab = {}
        Tab.Elements = {}
        
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Name = tabConfig.Name
        Tab.Button.Size = UDim2.new(1, -10, 0, 30)
        Tab.Button.Position = UDim2.new(0, 5, 0, 0)
        Tab.Button.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        Tab.Button.Text = tabConfig.Name
        Tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.Button.TextSize = 12
        Tab.Button.Font = Enum.Font.GothamMedium
        Tab.Button.Parent = GUI.TabContainer
        Tab.Button.AutoButtonColor = false
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = Tab.Button
        
        Tab.Container = Instance.new("ScrollingFrame")
        Tab.Container.Name = tabConfig.Name.."Container"
        Tab.Container.Size = UDim2.new(1, -10, 1, -5)
        Tab.Container.Position = UDim2.new(0, 5, 0, 5)
        Tab.Container.BackgroundTransparency = 1
        Tab.Container.ScrollBarThickness = 2
        Tab.Container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        Tab.Container.Visible = false
        Tab.Container.Parent = GUI.ContentContainer
        
        local ElementList = Instance.new("UIListLayout")
        ElementList.Parent = Tab.Container
        ElementList.SortOrder = Enum.SortOrder.LayoutOrder
        ElementList.Padding = UDim.new(0, 5)
        
        Tab.Button.MouseButton1Click:Connect(function()
            if GUI.ActiveTab then
                GUI.ActiveTab.Button.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
                GUI.ActiveTab.Container.Visible = false
            end
            
            GUI.ActiveTab = Tab
            Tab.Container.Visible = true
            Tab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
        
        function Tab:Button(config)
            local Button = GUI:CreateElement("Button", Tab.Container)
            
            local ButtonText = Instance.new("TextButton")
            ButtonText.Name = "ButtonText"
            ButtonText.Size = UDim2.new(1, 0, 1, 0)
            ButtonText.BackgroundTransparency = 1
            ButtonText.Text = config.Name
            ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonText.TextSize = 12
            ButtonText.Font = Enum.Font.GothamMedium
            ButtonText.Parent = Button
            
            ButtonText.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TWEEN_INFO, {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                }):Play()
                wait(0.1)
                TweenService:Create(Button, TWEEN_INFO, {
                    BackgroundColor3 = Color3.fromRGB(26, 26, 26)
                }):Play()
                config.Callback()
            end)
        end
        
        function Tab:Toggle(config)
            local Toggle = GUI:CreateElement("Toggle", Tab.Container)
            
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -50, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = config.Name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 12
            Title.Font = Enum.Font.GothamMedium
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Toggle
            
            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -45, 0.5, -10)
            Switch.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Switch.Text = ""
            Switch.Parent = Toggle
            
            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch
            
            local Ball = Instance.new("Frame")
            Ball.Size = UDim2.new(0, 16, 0, 16)
            Ball.Position = UDim2.new(0, 2, 0.5, -8)
            Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Ball.Parent = Switch
            
            local BallCorner = Instance.new("UICorner")
            BallCorner.CornerRadius = UDim.new(1, 0)
            BallCorner.Parent = Ball
            
            local Enabled = config.Default or false
            
            local function UpdateToggle()
                TweenService:Create(Ball, TWEEN_INFO, {
                    Position = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 255, 255)
                }):Play()
                
                config.Callback(Enabled)
            end
            
            Switch.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                UpdateToggle()
            end)
            
            UpdateToggle()
        end
        
        function Tab:Dropdown(config)
            local Dropdown = GUI:CreateElement("Dropdown", Tab.Container)
            Dropdown.Size = UDim2.new(1, 0, 0, 32)
            Dropdown.ClipsDescendants = true
            
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -30, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = config.Name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 12
            Title.Font = Enum.Font.GothamMedium
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Dropdown
            
            local Selected = config.Default or config.Options[1]
            local IsOpen = false
            
            local OptionContainer = Instance.new("Frame")
            OptionContainer.Size = UDim2.new(1, 0, 0, #config.Options * 32)
            OptionContainer.Position = UDim2.new(0, 0, 0, 32)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = Dropdown
            
            local function UpdateDropdown()
                Title.Text = config.Name..": "..Selected
                
                TweenService:Create(Dropdown, TWEEN_INFO, {
                    Size = IsOpen and UDim2.new(1, 0, 0, 32 + (#config.Options * 32)) or UDim2.new(1, 0, 0, 32)
                }):Play()
            end
            
            for i, option in ipairs(config.Options) do
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 32)
                Button.Position = UDim2.new(0, 0, 0, (i-1) * 32)
                Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Button.Text = option
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 12
                Button.Font = Enum.Font.GothamMedium
                Button.Parent = OptionContainer
                
                Button.MouseButton1Click:Connect(function()
                    Selected = option
                    IsOpen = false
                    UpdateDropdown()
                    config.Callback(Selected)
                end)
            end
            
            Dropdown.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    UpdateDropdown()
                end
            end)
            
            UpdateDropdown()
        end
        
        function Tab:Slider(config)
            local Slider = GUI:CreateElement("Slider", Tab.Container)
            Slider.Size = UDim2.new(1, 0, 0, 45)
            
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -50, 0, 32)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = config.Name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 12
            Title.Font = Enum.Font.GothamMedium
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Slider
            
            local Value = Instance.new("TextLabel")
            Value.Size = UDim2.new(0, 40, 0, 32)
            Value.Position = UDim2.new(1, -45, 0, 0)
            Value.BackgroundTransparency = 1
            Value.Text = tostring(config.Default or config.Min)
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 12
            Value.Font = Enum.Font.GothamMedium
            Value.Parent = Slider
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 0, 35)
            SliderBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            SliderBar.Parent = Slider
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(1, 0)
            SliderCorner.Parent = SliderBar
            
            local Progress = Instance.new("Frame")
            Progress.Size = UDim2.new(0.5, 0, 1, 0)
            Progress.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
            Progress.Parent = SliderBar
            
            local ProgressCorner = Instance.new("UICorner")
            ProgressCorner.CornerRadius = UDim.new(1, 0)
            ProgressCorner.Parent = Progress
            
            local Min, Max = config.Min or 0, config.Max or 100
            local Current = config.Default or Min
            
            local function Update(input)
                local pos = math.clamp((input - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Current = math.floor(Min + (Max - Min) * pos)
                
                TweenService:Create(Progress, TWEEN_INFO, {
                    Size = UDim2.new(pos, 0, 1, 0)
                }):Play()
                
                Value.Text = tostring(Current)
                config.Callback(Current)
            end
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input.Position.X)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input.Position.X)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            local initialPos = (Current - Min) / (Max - Min)
            Progress.Size = UDim2.new(initialPos, 0, 1, 0)
        end
        
        ElementList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.Container.CanvasSize = UDim2.new(0, 0, 0, ElementList.AbsoluteContentSize.Y + 5)
        end)
        
        if #GUI.Tabs == 0 then
            Tab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Tab.Container.Visible = true
            GUI.ActiveTab = Tab
        end
        
        table.insert(GUI.Tabs, Tab)
        return Tab
    end
    
    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        GUI.TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 5)
    end)
    
    return GUI
end

return Linux
