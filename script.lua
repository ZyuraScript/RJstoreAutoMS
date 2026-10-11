-- [[ RJstore Free Auto Marshmallow ]] --
-- Kompatibel dengan Delta Executor, Arceus X, Fluxus, dll.

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus UI lama jika ada agar tidak menumpuk
if PlayerGui:FindFirstChild("RJstoreAutoMS") then
    PlayerGui.RJstoreAutoMS:Destroy()
end

-- 1. Buat ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RJstoreAutoMS"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- 2. Buat Frame Utama (Background Dark & Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20) -- Background sangat gelap
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -140, 0.4, -160)
MainFrame.Size = UDim2.new(0, 280, 0, 330)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Efek Cahaya / Border Glow di sekeliling Frame
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 140, 255)
UIStroke.Thickness = 1.8
UIStroke.Transparency = 0.4

-- 3. Judul Script (Ukuran Font Diperkecil menjadi 13 agar proporsional)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.Size = UDim2.new(1, 0, 0, 22)
TitleLabel.Font = Enum.Font.Arcade -- Font Pixel Retro
TitleLabel.Text = "RJstore Free Auto Marshmallow"
TitleLabel.TextSize = 13 -- Diperkecil agar lebih pas dan tidak kebesaran

-- 4. Garis Pembatas
local Divider = Instance.new("Frame")
Divider.Parent = MainFrame
Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0.05, 0, 0, 38)
Divider.Size = UDim2.new(0.9, 0, 0, 1)

-- 5. Label Informasi Inventory (Bahan di Atas, MS Jadi di Tengah, Sisa MS di Bawah)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0.08, 0, 0, 48)
InfoLabel.Size = UDim2.new(0.84, 0, 0, 215)
InfoLabel.Font = Enum.Font.Arcade
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) -- Warna Biru Laut (Ocean Blue)
InfoLabel.TextSize = 15
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.TextWrapped = true

-- 6. Tombol Start / Stop AutoMS
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 160, 115)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.08, 0, 0.83, 0)
ToggleButton.Size = UDim2.new(0.84, 0, 0, 40)
ToggleButton.Font = Enum.Font.Arcade
ToggleButton.Text = "Start AutoMS"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- Variabel Status
local isRunning = false

-- Efek Pelangi Berjalan untuk Judul
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    TitleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- Fungsi Menghitung Item di Inventory Roblox Secara Otomatis
local function countItems()
    local smallCount, mediumCount, largeCount = 0, 0, 0
    local waterCount, sugarCount, gelatinCount = 0, 0, 0
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    
    local containers = {}
    if backpack then table.insert(containers, backpack) end
    if character then table.insert(containers, character) end
    
    for _, container in ipairs(containers) do
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local nameLower = string.lower(item.Name)
                if string.find(nameLower, "small") then smallCount = smallCount + 1 end
                if string.find(nameLower, "medium") then mediumCount = mediumCount + 1 end
                if string.find(nameLower, "large") then largeCount = largeCount + 1 end
                if string.find(nameLower, "water") then waterCount = waterCount + 1 end
                if string.find(nameLower, "sugar") then sugarCount = sugarCount + 1 end
                if string.find(nameLower, "gelatin") then gelatinCount = gelatinCount + 1 end
            end
        end
    end
    
    local sisaMS = sugarCount -- Sisa MS mengikuti jumlah Sugar Block Bag
    return smallCount, mediumCount, largeCount, waterCount, sugarCount, gelatinCount, sisaMS
end

-- Fungsi Otomatis Memegang Item (Equip Tool)
local function equipItem(keyword)
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    if not humanoid then return end
    
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), string.lower(keyword)) then
                return
            end
        end
    end
    
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), string.lower(keyword)) then
                humanoid:EquipTool(item)
                task.wait(0.3)
                break
            end
        end
    end
end

-- Fungsi Tekan Tombol 'E'
local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Loop Real-time Update Teks UI
task.spawn(function()
    while true do
        local small, medium, large, water, sugar, gelatin, sisa = countItems()
        
        InfoLabel.Text = string.format(
            "Bahan:\n - Water: %d\n - Sugar Block Bag: %d\n - Gelatin: %d\n\nMS Sudah Jadi:\n - Small: %d\n - Medium: %d\n - Large: %d\n\nSisa MS: %d",
            water, sugar, gelatin, small, medium, large, sisa
        )
        
        task.wait(0.5)
    end
end)

-- Event Tombol Start / Stop
ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    
    if isRunning then
        ToggleButton.Text = "Stop AutoMS"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah saat aktif
    else
        ToggleButton.Text = "Start AutoMS"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 160, 115) -- Hijau saat mati
    end
end)

-- Loop Utama Mekanisme AutoMS
task.spawn(function()
    while true do
        if isRunning then
            -- Langkah 1: Pegang Water -> Jeda 1 Detik -> Click E
            equipItem("water")
            task.wait(1)
            if not isRunning then continue end
            pressE()
            
            -- Langkah 2: Tunggu 20 Detik
            local timer = 20
            while timer > 0 and isRunning do
                task.wait(1)
                timer = timer - 1
            end
            if not isRunning then continue end
            
            -- Langkah 3: Pegang Sugar -> Click E
            equipItem("sugar")
            task.wait(0.3)
            if not isRunning then continue end
            pressE()
            task.wait(0.5)
            
            -- Langkah 4: Pegang Gelatin -> Click E
            equipItem("gelatin")
            task.wait(0.3)
            if not isRunning then continue end
            pressE()
            
            -- Langkah 5: Tunggu 45 Detik
            local timer2 = 45
            while timer2 > 0 and isRunning do
                task.wait(1)
                timer2 = timer2 - 1
            end
            if not isRunning then continue end
            
            -- Langkah 6: Pegang Empty Bag -> Click E
            equipItem("Empty bag")
            task.wait(0.3)
            if not isRunning then continue end
            pressE()
            
            task.wait(1)
        else
            task.wait(0.5)
        end
    end
end)
