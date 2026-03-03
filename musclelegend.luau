--[[ 
    c00lhayx Menu (MUSCLE LEGENDS) - MEGA BUNDLE v6.0
    [TABS] [SHIELD] [FARM] [NO CD,S] [TOOLS]
]]

-- 1. ЯДРО ЗАЩИТЫ (Anti-Kick & Anti-AFK)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" or getnamecallmethod() == "kick" then
        warn("c00lhayx Shield: Попытка кика заблокирована!")
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

local VU = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

-- 2. ГЛАВНЫЙ ИНТЕРФЕЙС
local ScreenGui = Instance.new("ScreenGui", game:GetService("PlayerGui"))
local Main = Instance.new("Frame", ScreenGui)
local Sidebar = Instance.new("Frame", Main)
local Content = Instance.new("Frame", Main)
local Title = Instance.new("TextLabel", Main)

Main.Name = "c00lhayx_MegaMenu"
Main.Size = UDim2.new(0, 400, 0, 350)
Main.Position = UDim2.new(0.5, -200, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Active = true
Main.Draggable = true

Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Text = "c00lhayx Menu ULTIMATE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

Sidebar.Size = UDim2.new(0, 100, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local SidebarList = Instance.new("UIListLayout", Sidebar)

Content.Size = UDim2.new(1, -100, 1, -40)
Content.Position = UDim2.new(0, 100, 0, 40)
Content.BackgroundTransparency = 1

-- Вкладки
local Pages = {
    Menu = Instance.new("ScrollingFrame", Content),
    NoCDs = Instance.new("ScrollingFrame", Content)
}

for _, p in pairs(Pages) do
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = false
    p.BackgroundTransparency = 1
    p.ScrollBarThickness = 4
    p.CanvasSize = UDim2.new(0, 0, 2.5, 0)
    local l = Instance.new("UIListLayout", p)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Padding = UDim.new(0, 5)
end
Pages.Menu.Visible = true

-- Функция создания вкладок
local function makeTab(name, page)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

makeTab("MENU", Pages.Menu)
makeTab("NO CD,S", Pages.NoCDs)

-- Функция создания кнопок
local function createBtn(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 270, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name .. ": OFF"
    local act = false
    btn.MouseButton1Click:Connect(function()
        act = not act
        btn.Text = name .. (act and ": ON" or ": OFF")
        btn.BackgroundColor3 = act and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
        callback(act)
    end)
end

-- === [ВКЛАДКА: MENU] ===
createBtn("Auto-Weight (PlayerSim)", Pages.Menu, function(s)
    _G.AW = s task.spawn(function() while _G.AW do
        local c = game.Players.LocalPlayer.Character
        local t = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight") or (c and c:FindFirstChild("Weight"))
        if t then c.Humanoid:EquipTool(t) t:Activate() end
        task.wait(0.12 + math.random()*0.05)
    end end)
end)

createBtn("Auto-Rebirth", Pages.Menu, function(s)
    _G.AR = s task.spawn(function() while _G.AR do
        game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
        task.wait(2)
    end end)
end)

createBtn("Auto-Gem (FireTouch)", Pages.Menu, function(s)
    _G.AG = s task.spawn(function() while _G.AG do
        pcall(function()
            for _, v in pairs(workspace.collectableItems:GetChildren()) do
                if v.Name == "Gem" then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end)
        task.wait(1)
    end end)
end)

createBtn("Unlock VIP Areas", Pages.Menu, function(s)
    for _, gym in pairs(workspace.Gyms:GetChildren()) do
        local d = gym:FindFirstChild("Door") or gym:FindFirstChild("Gate")
        if d then d.CanCollide = not s d.Transparency = s and 0.5 or 0 end
    end
end)

local SpdBox = Instance.new("TextBox", Pages.Menu)
SpdBox.Size = UDim2.new(0, 270, 0, 35)
SpdBox.PlaceholderText = "Speed (16 - 500)"
SpdBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpdBox.TextColor3 = Color3.new(1, 1, 1)

createBtn("Apply HackSpeed", Pages.Menu, function(s)
    _G.SS = s task.spawn(function() while _G.SS do
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(SpdBox.Text) or 16
        task.wait(0.1)
    end end)
end)

local ToolBox = Instance.new("TextBox", Pages.Menu)
ToolBox.Size = UDim2.new(0, 270, 0, 35)
ToolBox.PlaceholderText = "Drink: AgilityDrink"
ToolBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToolBox.TextColor3 = Color3.new(1, 1, 1)

createBtn("HackToolGiver", Pages.Menu, function()
    game:GetService("ReplicatedStorage").rEvents.shopEvent:FireServer("buyItem", ToolBox.Text)
end)

-- === [ВКЛАДКА: NO CD,S] ===
createBtn("Anti-CD Punch (Spam)", Pages.NoCDs, function(s)
    _G.NP = s task.spawn(function() while _G.NP do
        game:GetService("ReplicatedStorage").rEvents.punchEvent:FireServer("punchClick")
        task.wait(0.01)
    end end)
end)

createBtn("Anti-CD Weight (Spam)", Pages.NoCDs, function(s)
    _G.NW = s task.spawn(function() while _G.NW do
        game:GetService("ReplicatedStorage").rEvents.weightEvent:FireServer("weightClick")
        task.wait(0.01)
    end end)
end)

createBtn("Auto-Brawl (No Delay)", Pages.NoCDs, function(s)
    _G.NB = s task.spawn(function() while _G.NB do
        game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
        task.wait(0.5)
    end end)
end)

print("c00lhayx Menu MEGA BUNDLE Loaded!")
