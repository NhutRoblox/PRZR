-- ==================== LOAD RAYFIELD UI ====================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ==================== WINDOW ====================
local Window = Rayfield:CreateWindow({
    Name = "NhutCrack",
    LoadingTitle = "NHÌN CON CẶC",
    LoadingSubtitle = "by NhutDZ",
    ConfigurationSaving = {Enabled = true, FolderName = "NhutCrack", FileName = "Settings"}
})

local MainTab = Window:CreateTab("Main", 4483362458)
local PlayersTab = Window:CreateTab("Players", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local TrollTab = Window:CreateTab("Troll", 4483362458)
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

-- ==================== SETTINGS ====================
local Settings = {
    ESP = {Enabled = false, Distance = true, TeamCheck = false},
    Speed = {Enabled = false, Value = 16},
    Fly = {Enabled = false, Speed = 80},
    Jump = {Enabled = false, Value = 50}
}

local FOLDER_NAME = "NhutESP"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==================== INVISIBLE VARIABLES ====================
-- Mod Made By Bảo Béo
-- Source Gốc CKG_Studio (Strict Real-Time Character Pointer Fix)

local INVIS_POS = CFrame.new(4000, 4000, 4000)
local IsInvisible = false

local MainFrame = nil
local StatusLabel = nil
local invisConnections = {}

local function ApplyTransparency(char, value)
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA('BasePart') and part.Name ~= "HumanoidRootPart" then
            part.Transparency = value
        end
    end
end

local function ToggleInvisible()
    IsInvisible = not IsInvisible
    local char = LocalPlayer.Character
    if IsInvisible then
        ApplyTransparency(char, 0.5)
        LocalPlayer.ReplicationFocus = Camera
    else
        ApplyTransparency(char, 0)
        LocalPlayer.ReplicationFocus = nil
    end
    if StatusLabel then
        StatusLabel.Text = IsInvisible and "● ON" or "● OFF"
        StatusLabel.TextColor3 = IsInvisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
    end
end

local function CreateInvisibleGUI()
    if LocalPlayer.PlayerGui:FindFirstChild("InvisibleGUI") then
        LocalPlayer.PlayerGui.InvisibleGUI:Destroy()
        MainFrame = nil
        StatusLabel = nil
        return
    end

    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    if not playerGui then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "InvisibleGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = playerGui

    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 170, 0, 85)
    MainFrame.Position = UDim2.new(0.5, -85, 0.15, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0
    MainFrame.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.4
    stroke.Parent = MainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.55, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "INVISIBLE"
    titleLabel.TextScaled = false
    titleLabel.TextSize = 19
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Parent = MainFrame

    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0.45, 0)
    StatusLabel.Position = UDim2.new(0, 0, 0.55, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = IsInvisible and "● ON" or "● OFF"
    StatusLabel.TextScaled = false
    StatusLabel.TextSize = 17
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.TextColor3 = IsInvisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
    StatusLabel.Parent = MainFrame

    -- ===== KÉO THẢ CHO CẢ TOUCH VÀ CHUỘT =====
    local dragging = false
    local dragStartPos = nil
    local frameStartPos = nil
    local isClick = false

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            isClick = true
            dragStartPos = input.Position
            frameStartPos = MainFrame.Position
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                isClick = false
                local delta = input.Position - dragStartPos
                MainFrame.Position = UDim2.new(
                    frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
                    frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if isClick then
                ToggleInvisible()
            end
            isClick = false
        end
    end)

    Rayfield:Notify({
        Title = "Troll Mode",
        Content = "✅ Đã hiển thị nút tàng hình! (Nhấn G để tắt/bật)",
        Duration = 2,
    })
end

-- ==================== AIMBOT MOBILE CODE ====================
local aimbotLoaded = false
local aimbotGui = nil
local aimbotToggleState = false

local function LoadAimbot()
    if aimbotLoaded then
        Rayfield:Notify({
            Title = "Aimbot",
            Content = "⚠️ Aimbot đã được kích hoạt!",
            Duration = 2,
        })
        return
    end
    
    pcall(function()
        repeat task.wait() until game:IsLoaded()
        repeat task.wait() until game.Players.LocalPlayer

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        local UserInputService = game:GetService("UserInputService")

        local LocalPlayer = Players.LocalPlayer
        local Camera = Workspace.CurrentCamera

        local AimbotEnabled = true
        local FOV_RADIUS = 50
        local AIM_PART = "Head"
        local AIM_STRENGTH = 1

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AimbotMobileSystem_TeamFix"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.DisplayOrder = 9999999
        ScreenGui.IgnoreGuiInset = true

        local FOVFrame = Instance.new("Frame")
        FOVFrame.Name = "FOV_Circle"
        FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        FOVFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        FOVFrame.BackgroundTransparency = 0.95
        FOVFrame.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
        FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0) 
        FOVFrame.Parent = ScreenGui

        local UICornerFOV = Instance.new("UICorner")
        UICornerFOV.CornerRadius = UDim.new(1, 0)
        UICornerFOV.Parent = FOVFrame

        local UIStrokeFOV = Instance.new("UIStroke")
        UIStrokeFOV.Color = Color3.fromRGB(255, 0, 0)
        UIStrokeFOV.Thickness = 1.5
        UIStrokeFOV.Parent = FOVFrame

        local CenterDot = Instance.new("Frame")
        CenterDot.Name = "CenterDot"
        CenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
        CenterDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        CenterDot.Size = UDim2.new(0, 5, 0, 5)
        CenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
        CenterDot.Parent = FOVFrame

        local UICornerDot = Instance.new("UICorner")
        UICornerDot.CornerRadius = UDim.new(1, 0)
        UICornerDot.Parent = CenterDot

        local MobileToggleButton = Instance.new("TextButton")
        MobileToggleButton.Name = "MobileAimToggle"
        MobileToggleButton.Size = UDim2.new(0, 50, 0, 50)
        MobileToggleButton.Position = UDim2.new(0, 30, 0, 150)
        MobileToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        MobileToggleButton.BackgroundTransparency = 0.3
        MobileToggleButton.Text = "AIM"
        MobileToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MobileToggleButton.Font = Enum.Font.SourceSansBold
        MobileToggleButton.TextSize = 14
        MobileToggleButton.Active = true
        MobileToggleButton.Draggable = true
        MobileToggleButton.Parent = ScreenGui

        local UICornerBtn = Instance.new("UICorner")
        UICornerBtn.CornerRadius = UDim.new(1, 0)
        UICornerBtn.Parent = MobileToggleButton

        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        if PlayerGui then
            ScreenGui.Parent = PlayerGui
        end

        aimbotGui = ScreenGui

        MobileToggleButton.MouseButton1Click:Connect(function()
            AimbotEnabled = not AimbotEnabled
            FOVFrame.Visible = AimbotEnabled
            
            if AimbotEnabled then
                MobileToggleButton.Text = "AIM"
                MobileToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
            else
                MobileToggleButton.Text = "OFF"
                MobileToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
            end
        end)

        local function isVisible(targetPart)
            local origin = Camera.CFrame.Position
            local direction = targetPart.Position - origin
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local result = Workspace:Raycast(origin, direction, raycastParams)
            
            if not result or result.Instance:IsDescendantOf(targetPart.Parent) then
                return true
            end
            return false
        end
        
        local function isPlayerAlive(plr)
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            return hum and hum.Health > 0
        end

        local function getClosestPlayerToCenter()
            local closestPlayer = nil
            local shortestDistance = FOV_RADIUS
            local screenCenter = Camera.ViewportSize / 2 

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
                    local character = player.Character
                    local head = character:FindFirstChild(AIM_PART)
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if head and humanoid and humanoid.Health > 0 then
                        local vector, onScreen = Camera:WorldToViewportPoint(head.Position)

                        if onScreen then
                            local targetPos = Vector2.new(vector.X, vector.Y)
                            local distance = (targetPos - screenCenter).Magnitude

                            if distance < shortestDistance then
                                if isVisible(head) then
                                    shortestDistance = distance
                                    closestPlayer = character
                                end
                            end
                        end
                    end
                end
            end
            return closestPlayer
        end

        RunService.RenderStepped:Connect(function()
            if not AimbotEnabled or not isPlayerAlive(LocalPlayer) then 
                return 
            end
            
            if FOVFrame then
                FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            end

            local targetCharacter = getClosestPlayerToCenter()
            
            if targetCharacter then
                local targetHead = targetCharacter:FindFirstChild(AIM_PART)
                local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                
                if targetHead and targetHumanoid and targetHumanoid.Health > 0 then
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AIM_STRENGTH)
                end
            end
        end)

        aimbotLoaded = true
        aimbotToggleState = true
        
        Rayfield:Notify({
            Title = "Aimbot",
            Content = "✅ Đã kích hoạt Aimbot Mobile!",
            Duration = 3,
        })
    end)
end

local function UnloadAimbot()
    if aimbotGui then
        pcall(function()
            aimbotGui:Destroy()
        end)
        aimbotGui = nil
    end
    aimbotLoaded = false
    aimbotToggleState = false
    
    Rayfield:Notify({
        Title = "Aimbot",
        Content = "❌ Đã tắt Aimbot!",
        Duration = 2,
    })
end

-- ==================== FLY LOGIC ====================
local flying = false
local bv = nil
local bg = nil
local flyLoop = nil

local function StartFly()
    if flying then 
        StopFly()
        task.wait(0.1)
    end
    
    local char = LocalPlayer.Character
    if not char then
        task.wait(0.5)
        char = LocalPlayer.Character
        if not char then 
            warn("Không tìm thấy Character!")
            return 
        end
    end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not hrp then 
        warn("Không tìm thấy Humanoid hoặc HumanoidRootPart!")
        return 
    end
    
    flying = true
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = hrp
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 10000
    bg.Parent = hrp
    
    hrp.CanCollide = false
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part ~= hrp then
            part.CanCollide = false
        end
    end
    
    flyLoop = RunService.RenderStepped:Connect(function()
        if not Settings.Fly.Enabled then
            StopFly()
            return
        end
        
        local char = LocalPlayer.Character
        if not char or not char.Parent then
            StopFly()
            return
        end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if not hum or not hrp or not bv or not bg then
            StopFly()
            return
        end
        
        local cam = workspace.CurrentCamera
        local move = hum.MoveDirection
        
        bg.CFrame = cam.CFrame
        
        if move.Magnitude > 0 then
            local direction = Vector3.new(move.X, cam.CFrame.LookVector.Y, move.Z)
            bv.Velocity = direction.Unit * Settings.Fly.Speed
        else
            bv.Velocity = Vector3.zero
        end
        
        hrp.CanCollide = false
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part ~= hrp then
                part.CanCollide = false
            end
        end
    end)
end

local function StopFly()
    if not flying then return end
    
    flying = false
    
    if flyLoop then
        flyLoop:Disconnect()
        flyLoop = nil
    end
    
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if bv then
            bv:Destroy()
            bv = nil
        end
        
        if bg then
            bg:Destroy()
            bg = nil
        end
        
        if hrp then
            hrp.CanCollide = true
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Settings.Fly.Enabled then
        StartFly()
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    StopFly()
end)

-- ==================== UTILITY ====================
local function GetLocalRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function IsTeammate(plr)
    if not Settings.ESP.TeamCheck then return false end
    if not plr or not LocalPlayer then return false end
    return LocalPlayer.Team == plr.Team and LocalPlayer.Team ~= nil
end

-- ==================== SPEED & JUMP LOGIC ====================
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and not Settings.Fly.Enabled then
                if Settings.Speed.Enabled then
                    humanoid.WalkSpeed = Settings.Speed.Value
                elseif humanoid.WalkSpeed ~= 16 then
                    humanoid.WalkSpeed = 16
                end
                
                if Settings.Jump.Enabled then
                    humanoid.JumpPower = Settings.Jump.Value
                elseif humanoid.JumpPower ~= 50 then
                    humanoid.JumpPower = 50
                end
            end
        end)
    end
end)

-- ==================== CLEANUP ====================
local function CleanupPlayer(plr)
    if plr.Character and plr.Character:FindFirstChild(FOLDER_NAME) then
        plr.Character[FOLDER_NAME]:Destroy()
    end
end

-- ==================== ESP ====================
local function CreateESP(plr)
    if plr == LocalPlayer then return end
    
    local function Apply(character)
        if not character or not Settings.ESP.Enabled then return end
        if Settings.ESP.TeamCheck and IsTeammate(plr) then return end
        
        local root = GetRoot(character)
        if not root then return end
        
        if character:FindFirstChild(FOLDER_NAME) then character[FOLDER_NAME]:Destroy() end
        local folder = Instance.new("Folder", character)
        folder.Name = FOLDER_NAME
        
        local highlight = Instance.new("Highlight", folder)
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        if Settings.ESP.Distance then
            local billboard = Instance.new("BillboardGui", folder)
            billboard.Adornee = root
            billboard.Size = UDim2.new(0, 120, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextStrokeTransparency = 0
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.Text = "[0]"
            label.Name = "DistanceLabel"
        end
    end
    
    if plr.Character then Apply(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        Apply(char)
    end)
end

-- Cập nhật khoảng cách
RunService.RenderStepped:Connect(function()
    local myRoot = GetLocalRoot()
    if not myRoot then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local folder = plr.Character:FindFirstChild(FOLDER_NAME)
            local root = GetRoot(plr.Character)
            
            if folder and root and Settings.ESP.Enabled and Settings.ESP.Distance then
                local label = folder:FindFirstChild("DistanceLabel", true)
                if label then
                    label.Text = string.format("[%d]", math.floor((root.Position - myRoot.Position).Magnitude))
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    CreateESP(plr)
end)
Players.PlayerRemoving:Connect(CleanupPlayer)

-- ==================== YIELD SCRIPT ====================
local YieldEnabled = false

local function LoadYield()
    if YieldEnabled then
        Rayfield:Notify({
            Title = "Yield",
            Content = "⚠️ Yield đã được kích hoạt!",
            Duration = 2,
        })
        return
    end

    Rayfield:Notify({
        Title = "Yield",
        Content = "⏳ Đang tải Infinite Yield...",
        Duration = 2,
    })

    local success, err = pcall(function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'), true))()
    end)

    if success then
        YieldEnabled = true
        Rayfield:Notify({
            Title = "Yield",
            Content = "✅ Đã kích hoạt Infinite Yield!",
            Duration = 3,
        })
    else
        Rayfield:Notify({
            Title = "Yield",
            Content = "❌ Lỗi tải Yield: " .. tostring(err),
            Duration = 4,
        })
        warn("Lỗi khi tải Infinite Yield:", err)
    end
end

local function UnloadYield()
    if not YieldEnabled then
        Rayfield:Notify({
            Title = "Yield",
            Content = "⚠️ Yield chưa được kích hoạt!",
            Duration = 2,
        })
        return
    end

    YieldEnabled = false
    Rayfield:Notify({
        Title = "Yield",
        Content = "❌ Đã tắt Yield (vui lòng F9 hoặc reset game để xóa hoàn toàn)",
        Duration = 3,
    })
end

-- ==================== UI ====================
-- TAB MAIN
MainTab:CreateToggle({
    Name = "Fly", 
    CurrentValue = false, 
    Callback = function(v)
        Settings.Fly.Enabled = v
        if v then
            StartFly()
        else
            StopFly()
        end
    end
})

MainTab:CreateSlider({
    Name = "Fly Speed", 
    Range = {10, 250}, 
    Increment = 5, 
    CurrentValue = 80, 
    Callback = function(v)
        Settings.Fly.Speed = v
    end
})

-- TAB PLAYERS
PlayersTab:CreateToggle({
    Name = "Speed Hack", 
    CurrentValue = false, 
    Callback = function(v)
        Settings.Speed.Enabled = v
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid and not Settings.Fly.Enabled then
            humanoid.WalkSpeed = v and Settings.Speed.Value or 16
        end
    end
})

PlayersTab:CreateSlider({
    Name = "Speed Value", 
    Range = {16, 250}, 
    Increment = 1, 
    CurrentValue = 16, 
    Callback = function(v)
        Settings.Speed.Value = v
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid and Settings.Speed.Enabled and not Settings.Fly.Enabled then
            humanoid.WalkSpeed = v
        end
    end
})

PlayersTab:CreateToggle({
    Name = "Jump Hack", 
    CurrentValue = false, 
    Callback = function(v)
        Settings.Jump.Enabled = v
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid and not Settings.Fly.Enabled then
            humanoid.JumpPower = v and Settings.Jump.Value or 50
        end
    end
})

PlayersTab:CreateSlider({
    Name = "Jump Power", 
    Range = {50, 500}, 
    Increment = 5, 
    CurrentValue = 50, 
    Callback = function(v)
        Settings.Jump.Value = v
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid and Settings.Jump.Enabled and not Settings.Fly.Enabled then
            humanoid.JumpPower = v
        end
    end
})

-- TAB VISUAL
VisualTab:CreateToggle({
    Name = "ESP", 
    CurrentValue = false, 
    Callback = function(v)
        Settings.ESP.Enabled = v
        if not v then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local folder = plr.Character:FindFirstChild(FOLDER_NAME)
                    if folder then folder:Destroy() end
                end
            end
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                CreateESP(plr)
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Team Check (ESP)", 
    CurrentValue = false, 
    Callback = function(v) 
        Settings.ESP.TeamCheck = v
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild(FOLDER_NAME) then 
                plr.Character[FOLDER_NAME]:Destroy() 
            end
            if Settings.ESP.Enabled then
                CreateESP(plr)
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Distance ESP", 
    CurrentValue = true, 
    Callback = function(v) 
        Settings.ESP.Distance = v 
    end
})

-- ==================== AIMBOT TAB ====================
local aimbotActive = false

AimbotTab:CreateParagraph({
    Title = "🎯 Aimbot Mobile",
    Content = "Bật/tắt aimbot cho điện thoại"
})

AimbotTab:CreateButton({
    Name = "🎯 Bật/Tắt Aimbot", 
    Callback = function()
        if not aimbotActive then
            aimbotActive = true
            LoadAimbot()
        else
            aimbotActive = false
            UnloadAimbot()
        end
    end
})

AimbotTab:CreateParagraph({
    Title = "📖 Hướng Dẫn",
    Content = "1. Bấm 'Bật/Tắt Aimbot'\n2. Nút AIM sẽ xuất hiện trên màn hình\n3. Bấm nút AIM để bật/tắt aim\n4. Kéo nút AIM để di chuyển"
})

-- ==================== TROLL TAB ====================
TrollTab:CreateParagraph({
    Title = "👻 Tàng Hình",
    Content = "Bật/tắt chế độ tàng hình (Nhấn G để tắt/bật nhanh)"
})

TrollTab:CreateButton({
    Name = "👻 Hiển thị nút Tàng Hình", 
    Callback = function()
        CreateInvisibleGUI()
        if not MainFrame then
            Rayfield:Notify({
                Title = "Troll Mode",
                Content = "❌ Đã ẩn nút tàng hình!",
                Duration = 2,
            })
        end
    end
})

TrollTab:CreateButton({
    Name = "🔄 Reset Tàng Hình (Nếu bị lỗi)", 
    Callback = function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.LocalTransparencyModifier = 0
                    end
                end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.HealthDisplayDistance = 100
                    hum.NameDisplayDistance = 100
                end
            end
            IsInvisible = false
            LocalPlayer.ReplicationFocus = nil
            
            if LocalPlayer.PlayerGui:FindFirstChild("InvisibleGUI") then
                LocalPlayer.PlayerGui.InvisibleGUI:Destroy()
                MainFrame = nil
                StatusLabel = nil
            end
            
            Rayfield:Notify({
                Title = "Troll Mode",
                Content = "🔄 Đã reset tàng hình!",
                Duration = 2,
            })
        end)
    end
})

-- ==================== YIELD BUTTONS ====================
TrollTab:CreateParagraph({
    Title = "⚡ Infinite Yield",
    Content = "Script admin mạnh mẽ với hàng trăm lệnh"
})

TrollTab:CreateButton({
    Name = "⚡ Bật Yield (Admin Script)", 
    Callback = function()
        LoadYield()
    end
})

TrollTab:CreateButton({
    Name = "⛔ Tắt Yield (Reset trạng thái)", 
    Callback = function()
        UnloadYield()
    end
})

TrollTab:CreateParagraph({
    Title = "📖 Hướng Dẫn Sử Dụng Yield",
    Content = "1. Bấm 'Bật Yield' để kích hoạt\n2. Mở chat game gõ ';' + lệnh\n3. Ví dụ: ;fly, ;tp, ;kill all\n4. Gõ ';cmds' để xem tất cả lệnh"
})

-- ==================== INVISIBLE CONNECTIONS ====================
local UserInputService = game:GetService("UserInputService")

invisConnections[1] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        ToggleInvisible()
    end
end)

invisConnections[2] = RunService.Heartbeat:Connect(function()
    if not IsInvisible then return end
    local char = LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid or humanoid.Health <= 0 then return end

    local currentCFrame = rootPart.CFrame
    local originalCamOffset = humanoid.CameraOffset
    local offsetPosition = INVIS_POS:ToObjectSpace(currentCFrame).Position

    rootPart.CFrame = INVIS_POS
    humanoid.CameraOffset = offsetPosition

    RunService.RenderStepped:Wait()

    if rootPart and rootPart.Parent then
        rootPart.CFrame = currentCFrame
        humanoid.CameraOffset = originalCamOffset
    end
end)

invisConnections[3] = LocalPlayer.CharacterAdded:Connect(function(newChar)
    IsInvisible = false
    LocalPlayer.ReplicationFocus = nil
    if StatusLabel then
        StatusLabel.Text = "● OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    ApplyTransparency(newChar, 0)
end)

print("=== LOADED SUCCESSFULLY ===")
print("Bật Fly trong tab Main để bay!")
print("WASD: Di chuyển | Space: Lên | Shift: Xuống")
print("🎯 Tab Aimbot: Bật/tắt aimbot mobile!")
print("👻 Tab Troll: Bấm 'Hiển thị nút Tàng Hình' để xuất hiện nút!")
print("⚡ Tab Troll: Bấm 'Bật Yield' để kích hoạt Infinite Yield!")
