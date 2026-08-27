-- Shibuya Troll - SchoolRP
-- Charge ce script avec: loadstring(game:HttpGet("URL_DU_SCRIPT"))()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local Window = Rayfield:CreateWindow({
    Name = "Shibuya Troll | SchoolRP",
    Icon = "skull",
    LoadingTitle = "Shibuya Troll",
    LoadingSubtitle = "Chargement...",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ShibuyaTroll",
        FileName = "SchoolRP_Config"
    },
    KeySystem = false
})

local ESP = {Enabled = false, StaffOnly = false}
local Bypass = {AntiAFK = false, AntiKick = false, AntiBan = false}
local StaffRoles = {"Directeur", "Proviseur", "CPE", "Staff", "Secrétaire", "Professeur", "Surveillant", "Policier", "Admin", "Moderateur"}
local ESPObjects = {}

-- RÔLES
local RolesTab = Window:CreateTab("Rôles", "crown")
RolesTab:CreateSection("Administration")

RolesTab:CreateButton({
    Name = "👑 Directeur",
    Callback = function()
        local args = {[1] = "Directeur"}
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChangeRole"):FireServer(unpack(args))
        Rayfield:Notify({Title = "Rôle", Content = "Tu es Directeur !", Duration = 3})
    end
})

RolesTab:CreateButton({
    Name = "🎓 Proviseur",
    Callback = function()
        local args = {[1] = "Proviseur"}
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChangeRole"):FireServer(unpack(args))
        Rayfield:Notify({Title = "Rôle", Content = "Tu es Proviseur !", Duration = 3})
    end
})

RolesTab:CreateButton({
    Name = "📋 Secrétaire",
    Callback = function()
        local args = {[1] = "Secrétaire"}
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChangeRole"):FireServer(unpack(args))
        Rayfield:Notify({Title = "Rôle", Content = "Tu es Secrétaire !", Duration = 3})
    end
})

RolesTab:CreateButton({
    Name = "👮 CPE",
    Callback = function()
        local args = {[1] = "CPE"}
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChangeRole"):FireServer(unpack(args))
        Rayfield:Notify({Title = "Rôle", Content = "Tu es CPE !", Duration = 3})
    end
})

RolesTab:CreateButton({
    Name = "🛡️ Staff",
    Callback = function()
        local args = {[1] = "Staff"}
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChangeRole"):FireServer(unpack(args))
        Rayfield:Notify({Title = "Rôle", Content = "Tu es Staff !", Duration = 3})
    end
})

-- TROLL
local TrollTab = Window:CreateTab("Troll", "flame")
TrollTab:CreateSection("Emotes & Animations")

TrollTab:CreateButton({
    Name = "🥖 Emote BR (Baguette)",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://3333499508"
            local track = char.Humanoid:LoadAnimation(anim)
            track:Play()
        end
    end
})

TrollTab:CreateButton({
    Name = "🕺 Animation Troll",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4391200869"
            local track = char.Humanoid:LoadAnimation(anim)
            track:Play()
            track.Looped = true
        end
    end
})

TrollTab:CreateButton({
    Name = "🎭 Floss",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://5917459365"
            local track = char.Humanoid:LoadAnimation(anim)
            track:Play()
        end
    end
})

TrollTab:CreateButton({
    Name = "💃 Orange Justice",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://3338077978"
            local track = char.Humanoid:LoadAnimation(anim)
            track:Play()
        end
    end
})

TrollTab:CreateToggle({
    Name = "🔁 Spam Emote BR",
    CurrentValue = false,
    Flag = "SpamEmote",
    Callback = function(Value)
        _G.SpamEmote = Value
        while _G.SpamEmote do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://3333499508"
                local track = char.Humanoid:LoadAnimation(anim)
                track:Play()
                task.wait(1.5)
            end
            task.wait(0.5)
        end
    end
})

TrollTab:CreateSection("Fun")
TrollTab:CreateButton({
    Name = "👻 Invisible",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        end
    end
})

TrollTab:CreateButton({
    Name = "👤 Visible",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                end
            end
        end
    end
})

-- ESP
local ESPTab = Window:CreateTab("ESP", "eye")

local function ClearESP()
    for _, obj in pairs(ESPObjects) do
        if obj.Highlight then obj.Highlight:Destroy() end
        if obj.Billboard then obj.Billboard:Destroy() end
    end
    ESPObjects = {}
end

local function CreateESP(player, color)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ShibuyaESP"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.Parent = char
    
    local head = char:FindFirstChild("Head") or char:WaitForChild("HumanoidRootPart")
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ShibuyaName"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = color
    text.TextStrokeTransparency = 0
    text.TextScaled = true
    text.Text = player.Name
    text.Parent = billboard
    
    billboard.Parent = head
    table.insert(ESPObjects, {Highlight = highlight, Billboard = billboard})
end

local function UpdateESP()
    ClearESP()
    if not ESP.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local isStaff = false
            local role = player:GetAttribute("Role") or ""
            
            for _, staffRole in pairs(StaffRoles) do
                if role:find(staffRole) then
                    isStaff = true
                    break
                end
            end
            
            if ESP.StaffOnly then
                if isStaff then
                    CreateESP(player, Color3.fromRGB(255, 0, 0))
                end
            else
                CreateESP(player, isStaff and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0))
            end
        end
    end
end

ESPTab:CreateToggle({
    Name = "👁️ ESP All",
    CurrentValue = false,
    Flag = "ESPAll",
    Callback = function(Value)
        ESP.Enabled = Value
        ESP.StaffOnly = false
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "🚨 ESP Staff Only",
    CurrentValue = false,
    Flag = "ESPStaff",
    Callback = function(Value)
        ESP.Enabled = Value
        ESP.StaffOnly = Value
        UpdateESP()
    end
})

RunService.RenderStepped:Connect(function()
    if ESP.Enabled then
        UpdateESP()
    end
end)

-- ITEMS
local ItemsTab = Window:CreateTab("Items", "backpack")
ItemsTab:CreateSection("Objets Scolaires")

local itemsList = {
    {Name = "Chips", Icon = "🍿"},
    {Name = "Pomme", Icon = "🍎"},
    {Name = "Globe", Icon = "🌍"},
    {Name = "Stylo", Icon = "🖊️"},
    {Name = "Parapluie", Icon = "☂️"},
    {Name = "Trousse", Icon = "🎒"},
    {Name = "Livre", Icon = "📖"},
    {Name = "Cartable", Icon = "💼"},
    {Name = "Gomme", Icon = "🧼"},
    {Name = "Règle", Icon = "📏"},
    {Name = "Calculatrice", Icon = "🧮"},
    {Name = "Cahier", Icon = "📓"},
    {Name = "Crayon", Icon = "✏️"},
    {Name = "Colle", Icon = "🧴"},
    {Name = "Ciseaux", Icon = "✂️"},
    {Name = "Mappemonde", Icon = "🌐"},
    {Name = "Dictionnaire", Icon = "📕"}
}

for _, item in pairs(itemsList) do
    ItemsTab:CreateButton({
        Name = item.Icon .. " " .. item.Name,
        Callback = function()
            local args = {[1] = item.Name, [2] = 1}
            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GiveItem"):FireServer(unpack(args))
            Rayfield:Notify({Title = "Item", Content = item.Name .. " ajouté !", Duration = 2})
        end
    })
end

ItemsTab:CreateSection("Mass Give")
ItemsTab:CreateButton({
    Name = "💎 Tous les Items (x99)",
    Callback = function()
        for _, item in pairs(itemsList) do
            local args = {[1] = item.Name, [2] = 99}
            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GiveItem"):FireServer(unpack(args))
            task.wait(0.05)
        end
        Rayfield:Notify({Title = "Succès", Content = "Tous les items donnés !", Duration = 3})
    end
})

-- BYPASS
local BypassTab = Window:CreateTab("Bypass", "shield")
BypassTab:CreateSection("Protection")

BypassTab:CreateToggle({
    Name = "🛡️ Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        Bypass.AntiAFK = Value
        if Value then
            local vu = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                if Bypass.AntiAFK then
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
            Rayfield:Notify({Title = "Bypass", Content = "Anti-AFK activé", Duration = 2})
        end
    end
})

BypassTab:CreateToggle({
    Name = "🚫 Anti-Kick",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        Bypass.AntiKick = Value
        if Value then
            local mt = getrawmetatable(game)
            local old = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    Rayfield:Notify({Title = "Bypass", Content = "Kick bloqué !", Duration = 3})
                    return nil
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end
})

BypassTab:CreateToggle({
    Name = "🔒 Anti-Ban",
    CurrentValue = false,
    Flag = "AntiBan",
    Callback = function(Value)
        Bypass.AntiBan = Value
    end
})

BypassTab:CreateButton({
    Name = "🧹 Clear Logs",
    Callback = function()
        for i = 1, 100 do
            print(string.rep(" ", 1000))
        end
        Rayfield:Notify({Title = "Bypass", Content = "Logs nettoyées", Duration = 2})
    end
})

BypassTab:CreateButton({
    Name = "🎭 Spoof Name",
    Callback = function()
        local name = "Shibuya_" .. tostring(math.random(1000, 9999))
        LocalPlayer.DisplayName = name
        Rayfield:Notify({Title = "Bypass", Content = "Nom: " .. name, Duration = 2})
    end
})

-- SETTINGS
local SettingsTab = Window:CreateTab("Settings", "settings")

SettingsTab:CreateSlider({
    Name = "⚡ WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

SettingsTab:CreateSlider({
    Name = "🦘 JumpPower",
    Range = {50, 500},
    Increment = 10,
    Suffix = " power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end
})

SettingsTab:CreateButton({
    Name = "☀️ Full Bright",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
})

SettingsTab:CreateButton({
    Name = "🌙 Night Mode",
    Callback = function()
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.1
    end
})

SettingsTab:CreateButton({
    Name = "🔄 Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Rayfield:Notify({
    Title = "Shibuya Troll",
    Content = "Script chargé ! Bon jeu",
    Duration = 5,
    Image = "skull"
})

print("Shibuya Troll - SchoolRP Loaded")
