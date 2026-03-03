--[[ 
    c00lhayx Menu (MUSCLE LEGENDS) - THE FINALE
    Features: Auto-Weight, Auto-Rebirth, Speed Selector, 
    Auto-Brawl Win, Auto-Wheel, Anti-AFK, Freeze Pos, Player-Sim
]]

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local Scroll = Instance.new("ScrollingFrame", Main)
local UIList = Instance.new("UIListLayout", Scroll)

-- Стиль c00lhayx (Red & Dark)
Main.Name = "c00lhayx_Ultimate"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Position = UDim2.new(0.5, -110, 0.25, 0)
Main.Size = UDim2.new(0, 230, 0, 380)
Main.Active = true
Main.Draggable = true

Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Text = "c00lhayx Menu v3.0"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

Scroll.Size = UDim2.new(1, 0, 1, -40)
Scroll.Position = UDim2.new(0, 0, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 1.8, 0)
Scroll.ScrollBarThickness = 4

UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Симуляция игрока (Рандомные задержки)
local function pWait(base) task.wait(base + (math.random() * 0.04)) end

local function createBtn(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.Text = name .. ": OFF"
    local act = false
    btn.MouseButton1Click:Connect(function()
        act = not act
        btn.Text = name .. (act and ": ON" or ": OFF")
        btn.BackgroundColor3 = act and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
        callback(act)
    end)
end

-- 1. СЕЛЕКТОР СКОРОСТИ
local SpeedInput = Instance.new("TextBox", Scroll)
SpeedInput.Size = UDim2.new(0, 200, 0, 35)
SpeedInput.PlaceholderText = "Speed (16-500)"
SpeedInput.Text = ""
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInput.TextColor3 = Color3.new(1, 1, 1)

createBtn("Apply Speed", function(state)
    _G.SpeedLoop = state
    task.spawn(function()
        while _G.SpeedLoop do
            local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = tonumber(SpeedInput.Text) or 16 end
            task.wait(0.1)
        end
    end)
end)

-- 2. AUTO-WEIGHT (Кач)
createBtn("Auto-Weight", function(state)
    _G.Weight = state
    task.spawn(function()
        while _G.Weight do
            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight") or game.Players.LocalPlayer.Character:FindFirstChild("Weight")
            if tool then 
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
                tool:Activate() 
            end
            pWait(0.1)
        end
    end)
end)

-- 3. AUTO-REBIRTH (Добавил!)
createBtn("Auto-Rebirth", function(state)
    _G.Rebirth = state
    task.spawn(function()
        while _G.Rebirth do
            game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
            task.wait(2)
        end
    end)
end)

-- 4. AUTO-BRAWL WIN
createBtn("Auto-Brawl Win", function(state)
    _G.Brawl = state
    task.spawn(function()
        while _G.Brawl do
            game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
            local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and game.Workspace:FindFirstChild("BrawlRing") then
                root.CFrame = game.Workspace.BrawlRing.CFrame + Vector3.new(0, 5, 0)
            end
            task.wait(0.5)
        end
    end)
end)

-- 5. AUTO-WHEEL
createBtn("Auto-Wheel", function(state)
    _G.Wheel = state
    task.spawn(function()
        while _G.Wheel do
            game:GetService("ReplicatedStorage").rEvents.wheelClickEvent:FireServer()
            task.wait(10)
        end
    end)
end)

-- 6. FREEZE POS (Set Pos)
local savedPos = nil
createBtn("Freeze Pos", function(state)
    _G.Freeze = state
    if state then savedPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame end
    task.spawn(function()
        while _G.Freeze do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos
            task.wait()
        end
    end)
end)

-- 7. ANTI-AFK (Запуск сразу)
local VU = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

print("c00lhayx Menu Loaded! Anti-AFK Active.")
