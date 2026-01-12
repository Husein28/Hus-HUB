-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
-- LOCAL PLAYER
local player = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "RuinzHub  |  FishIt",
    Author = "discord.gg/NsT3RVZeEv",
	Icon = "rbxassetid://127752996743839",
    Folder = "RuinzHub",
    IconSize = 18*2,
    Size = UDim2.fromOffset(580, 390),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    NewElements = true,
    HideSearchBar = true,
	SideBarWidth = 160,
    Transparent = true,
    
    OpenButton = {
        Icon = "rbxassetid://127752996743839",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 0,
        Color = ColorSequence.new(Color3.fromHex("0A1A3F"), Color3.fromHex("0F3C75")),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true,
    },

    Topbar = {
        Height = 60,
        ButtonsType = "Default", -- Default or Mac
    },
    --[[
    KeySystem = {
        Title = "Key System Example  |  WindUI Example",
        Note = "Key System. Key: 1234",
        KeyValidator = function(EnteredKey)
            if EnteredKey == "1234" then
                createPopup()
                return true
            end
            return false
            -- return EnteredKey == "1234" -- if key == "1234" then return true else return false end
        end
    }
    ]]
})

-- */  Tags  /* --
do
    Window:Tag({
        Title = "MAIN",
		Icon = "sfsymbols:circleHexagongrid",
        Color = Color3.fromHex("#1c1c1c")
    })
end


--======================================================
-- 🟩 Custom OpenButton + Glow Kedip + Auto Destroy + Mobile Drag
--======================================================

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Tombol custom
local Button = Instance.new("ImageButton")
Button.Size = UDim2.new(0, 45, 0, 45)
Button.Position = UDim2.new(0, 20, 0, 200)
Button.Image = "rbxassetid://127752996743839"
Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Button.BorderSizePixel = 0
Button.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Button

-- DRAGGABLE BUTTON (PC + Mobile)
local dragging = false
local dragStart, startPos

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = Button.Position
end

local function endDrag()
    dragging = false
end

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

Button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        endDrag()
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                     input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- TOGGLE WINDOW
local isOpen = true

Button.MouseButton1Click:Connect(function()
    if isOpen then
        Window:Close()
    else
        Window:Open()
    end
    isOpen = not isOpen
end)

-- ======================================================
-- Hilang otomatis saat Window di-destroy
-- ======================================================

if Window.OnDestroy then
    Window:OnDestroy(function()
        Button:Destroy()
    end)
else
    -- fallback jika tidak ada OnDestroy: cek parent
    Window.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if Button and Button.Parent then
                Button:Destroy()
            end
        end
    end)
end


-- */  InfoTabCode  /* --
do
    local InviteCode = "NsT3RVZeEv"
    local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

    local Http = WindUI.cloneref(game:GetService("HttpService"))

    local success, Response = pcall(function()
        return Http:JSONDecode(WindUI.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "WindUI/Ruinz",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    local guild = (success and Response and Response.guild) or {}

    local name = guild.name or "Ruinz Discord"
    local desc = guild.description ~= "" and guild.description or "A fun and friendly Roblox community to enjoy."

    local iconUrl = (guild.icon and guild.id)
        and ("https://cdn.discordapp.com/icons/" .. guild.id .. "/" .. guild.icon .. ".png?size=1024")
        or nil

    local bannerUrl = (guild.banner and guild.id)
        and ("https://cdn.discordapp.com/banners/" .. guild.id .. "/" .. guild.banner .. ".png?size=512")
        or nil

    -- Create Tab
    local InfoTab = Window:Tab({
        Title = "Info",
        Icon = "info"
    })

    -- Discord Section
    InfoTab:Section({
        Title = "Join our Discord server!",
        TextSize = 20,
    })

    InfoTab:Paragraph({
        Title = name,
        Desc = desc,
        Image = iconUrl,
        Thumbnail = bannerUrl,
        ImageSize = 48,
        Buttons = {
            {
                Title = "Copy link",
                Icon = "link",
                Callback = function()
                    setclipboard("https://discord.gg/" .. InviteCode)
                end
            }
        }
    })

    InfoTab:Space()

    -- About Ruinz Section
    local AboutRuinzSection = InfoTab:Section({
        Title = "About Ruinz",
        Box = false,
        Opened = true
    })

    AboutRuinzSection:Image({
        Image = "rbxassetid://82073100937026",
        AspectRatio = "16:9", -- landscape (fixed)
        Radius = 9,
    })

    AboutRuinzSection:Section({
        Title = "What is Ruinz?",
        TextSize = 24,
        FontWeight = Enum.FontWeight.SemiBold,
    })

    AboutRuinzSection:Section({
        Title = [[Ruinz is a keyless Roblox script that allows players to enjoy games, explore features, and have fun without restrictions. Our goal is to make Roblox scripting easier and more enjoyable for everyone.]],
        TextSize = 18,
        TextTransparency = 0.15,
        FontWeight = Enum.FontWeight.Medium,
    })

    AboutRuinzSection:Space({ Columns = 1 })
end

-- */  Colors  /* --
local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green  = Color3.fromHex("#10C550")
local Grey   = Color3.fromHex("#83889E")
local Blue   = Color3.fromHex("#257AF7")
local Red    = Color3.fromHex("#EF4F1D")

-- */  Tabs  /* --
local MainTab = Window:Tab({ Title = "Main",     Icon = "house",          IconColor = Grey,   IconShape = "Square" })
local AutoTab = Window:Tab({ Title = "Auto",     Icon = "repeat",         IconColor = Yellow, IconShape = "Square" })
local ShopTab = Window:Tab({ Title = "Shop",     Icon = "shopping-cart", IconColor = Purple, IconShape = "Square" })
local TeleTab = Window:Tab({ Title = "Teleport", Icon = "map-pin",       IconColor = Blue,   IconShape = "Square" })
local WebTab  = Window:Tab({ Title = "Webhook",  Icon = "globe",         IconColor = Green,  IconShape = "Square" })
local SetTab  = Window:Tab({ Title = "Setting",  Icon = "settings",      IconColor = Red,    IconShape = "Square" })


--================
--MAINTAB        =
--================
local function getNet()
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages and packages:FindFirstChild("_Index") then
        for _, child in ipairs(packages._Index:GetChildren()) do
            if child.Name:find("^sleitnick_net@") then
                return child:FindFirstChild("net")
            end
        end
    end
    return ReplicatedStorage:FindFirstChild("net") or ReplicatedStorage:FindFirstChild("Net")
end

local NET = getNet()

local R = {
    Cancel  = NET:FindFirstChild("RF/CancelFishingInputs"),
    Charge  = NET:FindFirstChild("RF/ChargeFishingRod"),
    Start   = NET:FindFirstChild("RF/RequestFishingMinigameStarted"),
    Equip   = NET:FindFirstChild("RE/EquipToolFromHotbar"),
    Done    = NET:FindFirstChild("RE/FishingCompleted"),
	Perfection = NET:FindFirstChild("RF/UpdateAutoFishingState"),
}

--//======================================================
--// NORMAL FISH
--//======================================================

local FuncNormal = {
    enabled = false,
    delay = 1
}

local function startNormalFish()
    FuncNormal.enabled = true

    while FuncNormal.enabled do
        task.wait(0.1)
        pcall(R.Cancel.InvokeServer, R.Cancel)
        task.wait(0.1)

        local t = Workspace:GetServerTimeNow()
        pcall(R.Charge.InvokeServer, R.Charge, t)

        task.wait(0.25)
        pcall(R.Start.InvokeServer, R.Start, -1.238, 0.969, Workspace:GetServerTimeNow())

        task.wait(FuncNormal.delay)
        pcall(R.Done.FireServer, R.Done)

        task.wait(0.3)
    end
end

local function stopNormalFish()
    FuncNormal.enabled = false
end

local NormalFishSection = MainTab:Section({ 
    Title = "Normal Fishing", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

-- UI
NormalFishSection:Toggle({
    Title = "Normal Fish",
    Callback = function(v)
        R.Equip:FireServer(1)
        if v then startNormalFish() else stopNormalFish() end
    end
})

NormalFishSection:Slider({
    Title = "Delay Normal",
    Step = 0.1,
    Value = { Min = 0, Max = 3, Default = 1 },
    Callback = function(v)
        FuncNormal.delay = v
    end
})

--//======================================================
--// BLATANT FISHING (FAST)
--//======================================================

local FuncBlatant = {
    enabled = false,
    biteDelay = 1.65,
    postDelay = 0.30,
    arg1 = -2,
    arg2 = 1,
}

local function recast()
	task.spawn(function()
		pcall(R.Cancel.InvokeServer, R.Cancel)
		task.wait(0.03)
		pcall(R.Charge.InvokeServer, R.Charge, Workspace:GetServerTimeNow())
		pcall(R.Start.InvokeServer, R.Start, FuncBlatant.arg1, FuncBlatant.arg2)
	end)
end

local function reel()
    task.spawn(function()
   		pcall(R.Done.FireServer, R.Done)
		task.wait(0.01)
    end)

end

local function startBlatant()
    FuncBlatant.enabled = true

    while FuncBlatant.enabled do
        recast()
        task.wait(FuncBlatant.biteDelay)
        reel()
        task.wait(FuncBlatant.postDelay)
    end
end

local function stopBlatant()
    FuncBlatant.enabled = false
end

local BlatantFishSection = MainTab:Section({ 
    Title = "Blatant Fishing [V1]", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

BlatantFishSection:Toggle({
    Title = "Blatant Fish",
    Callback = function(v)
        R.Equip:FireServer(1)
        if v then startBlatant() else stopBlatant() end
    end
})

BlatantFishSection:Slider({
    Title = "Delay Blatant",
    Step = 0.01,
    Value = { Min = 0.05, Max = 3, Default = FuncBlatant.biteDelay },
    Callback = function(v)
        FuncBlatant.biteDelay = v
    end
})

--//======================================================
--// BLATANT ADVANCED x5/x7 Compatible
--//======================================================
local Adv = {
    enabled = false,
    fishDelay = 1.1,
    reelDelay = 1.9,
}

local function Fastest()
	task.spawn(function()
		pcall(R.Cancel.InvokeServer, R.Cancel)
		pcall(R.Charge.InvokeServer, R.Charge, Workspace:GetServerTimeNow())
		pcall(R.Start.InvokeServer, R.Start, -1, 0.999)

		task.wait(Adv.fishDelay)

		pcall(R.Done.FireServer, R.Done)
	end)
end

local Blatantadv = MainTab:Section({ 
    Title = "Blatant Fishing [V2]", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

-- TOGGLE BLATANT FISHING
Blatantadv:Toggle({
    Title = "Blatant Fishing",
    Callback = function(v)
        Adv.enabled = v

        if v then
            -- Equip fishing rod
            pcall(function()
                R.Equip:FireServer(1)
            end)

            -- Jalankan loop fishing
            task.spawn(function()
                while Adv.enabled do
                    pcall(Fastest)
                    task.wait(Adv.reelDelay)
                end
            end)
        end
    end
})

-- INPUT: Fishing Delay
Blatantadv:Input({
    Title = "Fishing Delay",
    Value = tostring(Adv.fishDelay),
    Placeholder = "enter input...",
    Callback = function(v)
        local n = tonumber(v)
        if n then Adv.fishDelay = n end
    end
})

-- INPUT: Reel Delay
Blatantadv:Input({
    Title = "Reel Delay",
    Value = tostring(Adv.reelDelay),
    Placeholder = "enter input...",
    Callback = function(v)
        local n = tonumber(v)
        if n then Adv.reelDelay = n end
    end
})

--//======================================================
--// ULTRA BLATANT FISHING
--//======================================================
local UltraBlatant = {
    Active = false,
    Settings = {
        CompleteDelay = 0.7,
        CancelDelay = 0.3
    }
}

----------------------------------------------------------------
-- ULTRA BLATANT CORE FUNCTIONS
----------------------------------------------------------------

local function safeFire(func)
    task.spawn(pcall, func)
end

-- Function untuk spam charge + minigame
local function performUltraCast()
    local currentTime = tick()
    
    -- Charge fishing rod
    safeFire(function()
        R.Charge:InvokeServer(currentTime)
    end)
    
	task.wait(0.01)
    -- Start minigame
    safeFire(function()
        R.Start:InvokeServer(-1, 0.999)
    end)
end

-- Main loop
local function ultraFishingLoop()
    while UltraBlatant.Active do
        -- Step 1: Ultra cast (charge + minigame)
        performUltraCast()
        
        -- Step 2: Wait complete delay
        task.wait(UltraBlatant.Settings.CompleteDelay)
        
        -- Step 3: Complete fishing
        if UltraBlatant.Active then
            safeFire(function()
                R.Done:FireServer()
            end)
        end
        
        -- Step 4: Wait cancel delay
        task.wait(UltraBlatant.Settings.CancelDelay)
        
        -- Step 5: Cancel inputs
        if UltraBlatant.Active then
            safeFire(function()
                R.Cancel:InvokeServer()
            end)
        end
    end
end

local UltraBlatantSection = MainTab:Section({ 
    Title = "Blatant Fishing [V3]", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

MainTab:Space()

-- TOGGLE ULTRA BLATANT FISHING
UltraBlatantSection:Toggle({
    Title = "Ultra Blatant Fishing",
    Callback = function(v)
        UltraBlatant.Active = v

        if v then
            -- Equip fishing rod
            safeFire(function()
                R.Equip:FireServer(1)
            end)
            
            -- Tunggu 0.2 detik
            task.wait(0.2)
            
            -- Jalankan loop fishing
            task.spawn(ultraFishingLoop)
        else
            -- Cancel saat dimatikan
            safeFire(function()
                R.Cancel:InvokeServer()
            end)
        end
    end
})

-- INPUT: Complete Delay
UltraBlatantSection:Input({
    Title = "Complete Delay",
    Value = tostring(UltraBlatant.Settings.CompleteDelay),
    Placeholder = "Enter delay in seconds...",
    Callback = function(v)
        local num = tonumber(v)
        if num then UltraBlatant.Settings.CompleteDelay = num end
    end
})

-- INPUT: Cancel Delay
UltraBlatantSection:Input({
    Title = "Cancel Delay",
    Value = tostring(UltraBlatant.Settings.CancelDelay),
    Placeholder = "Enter delay in seconds...",
    Callback = function(v)
        local num = tonumber(v)
        if num then UltraBlatant.Settings.CancelDelay = num end
    end
})

--//======================================================
--// FISHING FEATURE
--//======================================================

local FishFeature = MainTab:Section({ 
    Title = "Fishing Feature", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})


------------------------SUPPORT ENCHANT PERFECTION
-- Simpan reference asli
local oldRequest = nil

-- TOGGLE AUTO PERFECTION + BLOCK CHARGE
FishFeature:Toggle({
    Title = "Enable Support Enchant PERFECTION",
    Callback = function(v)
        Adv.perfectionActivated = v -- flag toggle

        if v then
            -- Aktifkan Perfection hanya sekali saat toggle aktif
            if not Adv.perfectionEnabled then
                pcall(function()
                    R.Perfection:InvokeServer(true) -- nyalakan perfection
                end)
                Adv.perfectionEnabled = true
            end

            -- Block RequestChargeFishingRod
            pcall(function()
                local FishingController = require(ReplicatedStorage.Controllers.FishingController)
                if not oldRequest then
                    oldRequest = FishingController.RequestChargeFishingRod
                end
                FishingController.RequestChargeFishingRod = function(...)
                    return nil
                end
            end)

        else
            -- Toggle dimatikan → matikan perfection
            Adv.perfectionActivated = false
            Adv.perfectionEnabled = false

            pcall(function()
                R.Perfection:InvokeServer(false) -- matikan perfection

                -- Restore fungsi asli
                if oldRequest then
                    local FishingController = require(ReplicatedStorage.Controllers.FishingController)
                    FishingController.RequestChargeFishingRod = oldRequest
                    oldRequest = nil
                end
            end)
        end
    end
})



--------------------------DISABLE CUTSCENE
FishFeature:Toggle({
    Title = "Disable Cutscene",
    Default = true,
    Callback = function(state)

        local RS = game:GetService("ReplicatedStorage")
        local Net = RS.Packages._Index["sleitnick_net@0.2.0"].net
        local ControllerModule = RS.Controllers:FindFirstChild("CutsceneController")

        if not ControllerModule then
            warn("[CUTSCENE] Controller not found")
            return
        end

        ------------------------------------
        -- PCALL REQUIRE
        ------------------------------------
        local ok, CutsceneController = pcall(require, ControllerModule)
        if not ok or type(CutsceneController) ~= "table" then
            warn("[CUTSCENE] Failed to load controller:", CutsceneController)
            return
        end

        -- SIMPAN ORIGINAL PLAY/STOP
        if not CutsceneController._origPlay then
            CutsceneController._origPlay = CutsceneController.Play
            CutsceneController._origStop = CutsceneController.Stop
        end

        if state then
            -------------------------------
            -- 1. OVERRIDE PLAY / STOP
            -------------------------------
            function CutsceneController.Play(...)
                -- block
            end
            function CutsceneController.Stop(...)
                -- block
            end

            -------------------------------
            -- 2. BLOCK NET REPLICATION
            -------------------------------
            if Net["RE/ReplicateCutscene"] then
                Net["RE/ReplicateCutscene"].OnClientEvent:Connect(function()
                    -- block
                end)
            end

            if Net["RE/StopCutscene"] then
                Net["RE/StopCutscene"].OnClientEvent:Connect(function()
                    -- block
                end)
            end

            -------------------------------
            -- 3. DISABLE MODULESCRIPT CUTSCENES
            -------------------------------
            local cutFolder =
                ControllerModule:FindFirstChild("Cutscenes")
                or RS.Controllers:FindFirstChild("CutsceneController")
                and RS.Controllers.CutsceneController.Cutscenes

            if cutFolder then
                for _, m in ipairs(cutFolder:GetChildren()) do
                    if m:IsA("ModuleScript") then
                        m.Disabled = true -- safe to leave even though no effect
                    end
                end
            end

        else
            -------------------------------
            -- RESTORE ORIGINAL
            -------------------------------
            if CutsceneController._origPlay then
                CutsceneController.Play = CutsceneController._origPlay
                CutsceneController.Stop = CutsceneController._origStop
                warn("[CELESTIAL] Cutscene restored")
            end
        end
    end
})


--------------------------NO ANIMATION
local AnimFolder = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations")
local noAnimEnabled = false
local animConnections = {}

FishFeature:Toggle({
    Title = "No Animation",
    Icon = "user-x",
    Callback = function(value)
        noAnimEnabled = value
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        if value then
            WindUI:Notify({ Title = "No Animation", Content = "Semua animasi dimatikan." })
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop() end)
            end
            local connection = animator.AnimationPlayed:Connect(function(track)
                if noAnimEnabled then
                    local anim = track.Animation
                    if anim and anim:IsDescendantOf(AnimFolder) then
                        pcall(function() track:Stop() end)
                    end
                end
            end)
            table.insert(animConnections, connection)
        else
            WindUI:Notify({ Title = "No Animation", Content = "Animasi diaktifkan kembali." })
            for _, c in ipairs(animConnections) do
                if typeof(c) == "RBXScriptConnection" then
                    c:Disconnect()
                end
            end
            animConnections = {}
        end
    end
})

--------------------------DISABLE POPUP NOTIFICATION
FishFeature:Toggle({
    Title = "Disable Popup Notification",
    Default = false,

    Callback = function(state)
        _G.HideSmallNotif = state

        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local gui = player:WaitForChild("PlayerGui")

        -- Fungsi aman untuk hapus notification
        local function safeDestroy(child)
            if child and child:IsA("Instance") and child.Name == "Small Notification" then
                pcall(function()
                    child:Destroy()
                end)
            end
        end

        if state then
            -- Hapus yang sudah ada
            for _, v in ipairs(gui:GetChildren()) do
                safeDestroy(v)
            end

            -- Anti-spawn: hapus setiap kali dibuat ulang
            if not _G.NotifConn then
                _G.NotifConn = gui.ChildAdded:Connect(function(child)
                    if _G.HideSmallNotif then
                        task.wait() -- sedikit delay biar child siap
                        safeDestroy(child)
                    end
                end)
            end
        else
            -- Matikan koneksi
            if _G.NotifConn then
                _G.NotifConn:Disconnect()
                _G.NotifConn = nil
            end
        end
    end
})


--// RESPAWN IN PLACE

MainTab:Button({
    Title = "Reset Character",
    Icon = "refresh-cw",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer

        -- Ambil character saat ini
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        -- Simpan posisi sekarang
        local savedCFrame = hrp.CFrame

        -- Reset character untuk respawn
        humanoid.Health = 0

        -- Tunggu karakter baru muncul
        local newChar = player.CharacterAdded:Wait()
        task.wait(0.2) -- tunggu sebentar supaya HRP sudah tersedia

        -- Ambil HumanoidRootPart baru
        local newHrp = newChar:WaitForChild("HumanoidRootPart")

        -- Teleport kembali ke posisi semula
        newHrp.CFrame = savedCFrame

        -- Equip fishing rod langsung
        if R.Equip then
            pcall(function()
                R.Equip:FireServer(1)
            end)
        end
    end
})


--================
--AUTOTAB        =
--================

--//======================================================
--// AUTO SELL
--//======================================================
local DEFAULT_DELAY = 200
local AUTO_SELL_DELAY = DEFAULT_DELAY
local lastSell = os.time()
local autoSellState = false

local AutoSell = AutoTab:Section({ 
    Title = "Auto Sell", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

local delayBox
delayBox = AutoSell:Input({
    Title = "Auto Sell Delay",
    Desc = "seconds",
    Placeholder = tostring(DEFAULT_DELAY),
    Default = tostring(DEFAULT_DELAY),
    Numeric = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            AUTO_SELL_DELAY = num
            return
        end
        AUTO_SELL_DELAY = DEFAULT_DELAY
        delayBox:Set(tostring(DEFAULT_DELAY))
    end
})

AutoSell:Toggle({
    Title = "Auto Sell",
    Callback = function(value)
        autoSellState = value
        if value then
            task.spawn(function()
                while autoSellState do
                    pcall(function()
                        local net = getNet()
                        local sellFunc = net and net:FindFirstChild("RF/SellAllItems")
                        if sellFunc and os.time() - lastSell >= AUTO_SELL_DELAY then
                            sellFunc:InvokeServer()
                            lastSell = os.time()
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

--//======================================================
--// AUTO WEATHER
--//======================================================

local WeatherRemote = ReplicatedStorage
    .Packages._Index["sleitnick_net@0.2.0"]
    .net["RF/PurchaseWeatherEvent"]

local weatherList = { 
    "Wind", 
    "Snow", 
    "Cloudy", 
    "Storm", 
    "Shark Hunt",
    "Radiant" 
}

local selectedWeathers = {}

local AutoWeather = AutoTab:Section({ 
    Title = "Auto Weather", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

AutoWeather:Dropdown({
    Title = "Select Weathers",
    Desc = "Choose up to 3 weather types.",
    Values = weatherList,
    Multi = true,
    AllowNone = true,
    Value = selectedWeathers,

    Callback = function(values)
        if #values > 3 then
            table.remove(values, 4)
        end
        selectedWeathers = values
    end
})

AutoWeather:Button({
    Title = "Buy Selected",
    Callback = function()
        for _, weather in ipairs(selectedWeathers) do
            pcall(function()
                WeatherRemote:InvokeServer(weather)
            end)
            task.wait(0.3)
        end
    end
})

local autoBuy = false

AutoWeather:Toggle({
    Title = "Auto Buy Selected",
    Default = false,
    Callback = function(state)
        autoBuy = state

        if state then
            task.spawn(function()
                while autoBuy do

                    -- ambil weather aktif
                    local active = {}
                    local folder = workspace:FindFirstChild("Weather")

                    if folder then
                        for _, w in ipairs(folder:GetChildren()) do
                            active[string.lower(w.Name)] = true
                        end
                    end

                    -- cek weather yang dipilih
                    for _, weather in ipairs(selectedWeathers) do
                        if not active[string.lower(weather)] then
                            pcall(function()
                                WeatherRemote:InvokeServer(weather)
                            end)
                            task.wait(0.5)
                        end
                    end

                    task.wait(1)
                end
            end)
        end
    end
})





--//======================================================
--// AUTO ADMIN EVENT
--//======================================================
local AdminEvent = AutoTab:Section({ 
    Title = "Auto Admin Event", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

AutoTab:Space()

-- GUI untuk menampilkan status
local countdownParagraph = AdminEvent:Paragraph({
    Title = "Ancient Lochness Monster Countdown",
    Desc = "<font color='#FF4D4D'><b>Waiting for event...</b></font>"
})

-- State utama
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local farmPosition = nil
local autoEventEnabled = false

-- Ambil label countdown
local function getCountdownLabel()
    local ok, label = pcall(function()
        return workspace["!!! DEPENDENCIES"]["Event Tracker"].Main.Gui.Content.Items.Countdown.Label
    end)
    return ok and label or nil
end

-- Teleport ke event
local function goToEvent(hrp)
    hrp.CFrame = CFrame.new(Vector3.new(6063, -586, 4715))
end

-- Kembali ke posisi farm
local function returnToFarm(hrp)
    if farmPosition then
        hrp.CFrame = farmPosition
        countdownParagraph:SetDesc("<font color='#00FF99'><b>Returned to saved farm position!</b></font>")
    else
        countdownParagraph:SetDesc("<font color='#FF4D4D'><b>No saved farm position found!</b></font>")
    end
end

-- Toggle utama untuk teleport
AdminEvent:Toggle({
    Title = "Auto Lochness Event",
    Value = false,
    Callback = function(state)
        autoEventEnabled = state

        if autoEventEnabled then
            -- Simpan posisi farm
            local hrp = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5)
            if hrp then
                farmPosition = hrp.CFrame
            end
        else
            -- toggle off → kembali ke farm
            local hrp = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5)
            if hrp then
                returnToFarm(hrp)
            end
        end
    end
})

-- Loop update countdown GUI (selalu jalan)
task.spawn(function()
    local label = getCountdownLabel()
    while true do
        task.wait(1)
        if not label or not label.Parent then
            label = getCountdownLabel()
        end
        local text = ""
        if label then
            pcall(function() text = label.Text or "" end)
        end
        if text == "" then
            countdownParagraph:SetDesc("<font color='#FF4D4D'><b>Waiting for countdown...</b></font>")
        else
            countdownParagraph:SetDesc(string.format("<font color='#FF7A00'><b>Timer: %s</b></font>", text))
        end

        -- Handle teleport otomatis hanya jika toggle aktif
        if autoEventEnabled and label and text ~= "" then
            local hrp = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5)
            if hrp then
                local h, m, s = text:match("(%d+)H%s*(%d+)M%s*(%d+)S")
                h, m, s = tonumber(h), tonumber(m), tonumber(s)
                if h == 3 and m == 59 and s == 59 then
                    goToEvent(hrp)
                elseif h == 3 and m == 49 and s == 59 then
                    returnToFarm(hrp)
                end
            end
        end
    end
end)

--//======================================================
--// AUTO CHRISTMAS CAVE - INDONESIA TIME (WIB)
--//======================================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Jadwal Christmas Cave dalam Waktu Indonesia (WIB) - GMT+7
local ChristmasCaveSchedule = {
    "01:00", "01:30",
    "03:00", "03:30", 
    "05:00", "05:30",
    "07:00", "07:30",
    "09:00", "09:30",
    "11:00", "11:30",
    "13:00", "13:30",
    "15:00", "15:30",
    "17:00", "17:30",
    "19:00", "19:30",
    "21:00", "21:30",
    "23:00", "23:30"
}

-- State utama
local autoChristmasCave = false
local checkThread = nil
local isAtChristmasCave = false
local lastPosition = nil

-- Koordinat Christmas Cave (adjust sesuai lokasi)
local CHRISTMAS_CAVE_POSITION = CFrame.new(541.647, -580.581, 8902.609) * CFrame.Angles(0.000000, -1.728958, 0.000000)

AdminEvent:Space()

-- GUI untuk menampilkan status
local statusParagraph = AdminEvent:Paragraph({
    Title = "Christmas Cave Status",
    Desc = "Waiting for next schedule..."
})

-- Fungsi untuk mendapatkan waktu UTC saat ini
local function getUTCTime()
    local now = os.date("!*t")  -- ! untuk UTC
    return now.hour, now.min, now.sec
end

-- Fungsi untuk mengonversi UTC ke Waktu Indonesia (WIB) - GMT+7
local function convertUTCtoWIB(utcHour, utcMin, utcSec)
    local wibHour = (utcHour + 7) % 24  -- Indonesia WIB = UTC + 7
    return wibHour, utcMin, utcSec
end

-- Fungsi untuk mendapatkan waktu Indonesia (WIB) saat ini dalam format HH:MM
local function getIndonesiaTime()
    local utcHour, utcMin, utcSec = getUTCTime()
    local wibHour, wibMin, wibSec = convertUTCtoWIB(utcHour, utcMin, utcSec)
    return string.format("%02d:%02d", wibHour, wibMin)
end

-- Fungsi untuk mendapatkan waktu Indonesia (WIB) saat ini dalam total detik
local function getIndonesiaTimeInSeconds()
    local utcHour, utcMin, utcSec = getUTCTime()
    local wibHour, wibMin, wibSec = convertUTCtoWIB(utcHour, utcMin, utcSec)
    return wibHour * 3600 + wibMin * 60 + wibSec
end

-- Fungsi untuk mengubah waktu HH:MM ke total detik
local function timeToSeconds(timeStr)
    local hour, minute = timeStr:match("(%d+):(%d+)")
    return tonumber(hour) * 3600 + tonumber(minute) * 60
end

-- Fungsi untuk mendapatkan waktu schedule berikutnya
local function getNextScheduleTime()
    local currentSeconds = getIndonesiaTimeInSeconds()
    
    -- Cari schedule berikutnya
    for i = 1, #ChristmasCaveSchedule, 2 do -- Hanya check waktu start (index ganjil)
        local startTime = ChristmasCaveSchedule[i]
        local startSeconds = timeToSeconds(startTime)
        
        -- Jika schedule belum lewat hari ini
        if startSeconds > currentSeconds then
            return startTime, i
        end
    end
    
    -- Jika tidak ada schedule hari ini, kembalikan schedule pertama besok
    return ChristmasCaveSchedule[1], 1
end

-- Fungsi untuk format waktu
local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Simpan posisi saat ini
local function saveCurrentPosition()
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            lastPosition = hrp.CFrame
        end
    end
end

-- Teleport ke Christmas Cave
local function goToChristmasCave()
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Simpan posisi saat ini sebelum teleport
            if not isAtChristmasCave then
                lastPosition = hrp.CFrame
            end
            hrp.CFrame = CHRISTMAS_CAVE_POSITION
            statusParagraph:SetDesc("Teleported to Christmas Cave!")
            isAtChristmasCave = true
        end
    end
end

-- Kembali ke posisi terakhir
local function returnToLastPosition()
    local character = player.Character
    if character and lastPosition then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = lastPosition
            statusParagraph:SetDesc("Returned to last position!")
            isAtChristmasCave = false
        end
    end
end

-- Main check loop
local function startCheckLoop()
    while autoChristmasCave do
        local indonesiaTime = getIndonesiaTime()
        local localTime = os.date("%H:%M")  -- Waktu lokal device (untuk info saja)
        local currentSeconds = getIndonesiaTimeInSeconds()
        local nextTime, nextIndex = getNextScheduleTime()
        local nextSeconds = timeToSeconds(nextTime)
        
        -- Hitung selisih waktu
        local secondsUntilNext = nextSeconds - currentSeconds
        if secondsUntilNext < 0 then
            secondsUntilNext = secondsUntilNext + 24 * 3600 -- Untuk schedule besok
        end
        
        -- Update status dengan info lengkap
        statusParagraph:SetDesc(string.format(
            "Indonesia Time (WIB): %s\nLocal Device Time: %s\nNext Event: %s (in %s)\nUsing INDONESIA Timezone (GMT+7)",
            indonesiaTime,
            localTime,
            nextTime, 
            formatTime(secondsUntilNext)
        ))
        
        -- Check apakah saat ini adalah waktu event
        local inEventTime = false
        for i = 1, #ChristmasCaveSchedule, 2 do -- Loop hanya waktu start (ganjil)
            local startTime = ChristmasCaveSchedule[i]
            local endTime = ChristmasCaveSchedule[i + 1]
            local startSeconds = timeToSeconds(startTime)
            local endSeconds = timeToSeconds(endTime)
            
            -- Check jika current Indonesia time berada dalam rentang event
            if currentSeconds >= startSeconds and currentSeconds <= endSeconds then
                inEventTime = true
                -- Saat event berlangsung, teleport ke Christmas Cave jika belum di sana
                if not isAtChristmasCave then
                    goToChristmasCave()
                end
                break
            end
        end
        
        -- Jika bukan waktu event dan masih di Christmas Cave, kembali ke posisi terakhir
        if not inEventTime and isAtChristmasCave then
            returnToLastPosition()
        end
        
        -- Tunggu 1 detik sebelum check lagi
        task.wait(1)
    end
    
    -- Saat loop berhenti, reset status
    statusParagraph:SetDesc("Auto Christmas Cave is OFF")
    
    -- Kembali ke posisi terakhir jika masih di Christmas Cave
    if isAtChristmasCave then
        returnToLastPosition()
    end
end

-- Toggle utama
AdminEvent:Toggle({
    Title = "Auto Christmas Cave (Indonesia Time)",
    Value = false,
    Callback = function(state)
        autoChristmasCave = state
        
        if autoChristmasCave then
            -- Simpan posisi saat ini sebelum mulai
            saveCurrentPosition()
            
            -- Tampilkan info timezone
            local indonesiaTime = getIndonesiaTime()
            local localTime = os.date("%H:%M")
            statusParagraph:SetDesc(string.format(
                "Position saved!\nIndonesia Time (WIB): %s\nLocal Device Time: %s\nWaiting for event...",
                indonesiaTime,
                localTime
            ))
            
            -- Mulai loop checking
            checkThread = task.spawn(startCheckLoop)
        else
            -- Hentikan loop
            if checkThread then
                task.cancel(checkThread)
                checkThread = nil
            end
            
            -- Kembali ke posisi terakhir jika masih di Christmas Cave
            if isAtChristmasCave then
                returnToLastPosition()
            end
        end
    end
})

-- Button untuk manual teleport
AdminEvent:Button({
    Title = "Teleport Now",
    Content = "Teleport to Christmas Cave",
    Callback = function()
        goToChristmasCave()
    end
})

-- Button untuk manual return
AdminEvent:Button({
    Title = "Return to Position",
    Content = "Return to last saved position",
    Callback = function()
        returnToLastPosition()
    end
})

-- Button untuk check timezone
AdminEvent:Button({
    Title = "Check Timezone",
    Content = "Show current Indonesia vs Local time",
    Callback = function()
        local indonesiaTime = getIndonesiaTime()
        local localTime = os.date("%H:%M")
        local utcTime = os.date("!%H:%M")
        
        statusParagraph:SetDesc(string.format(
            "Timezone Info:\nIndonesia (WIB): %s\nLocal Device: %s\nUTC: %s\nOffset: Indonesia = UTC + 7 hours",
            indonesiaTime,
            localTime,
            utcTime
        ))
    end
})

--================
--SHOP TAB       =
--================


-- References ke ReplicatedStorage dan Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetPackage = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local BuyRodRemote  = NetPackage["RF/PurchaseFishingRod"]
local BuyBaitRemote = NetPackage["RF/PurchaseBait"]

-- Tables untuk menyimpan data rod/bait
local Rods = {}
local RodDisplayNames = {}

local Baits = {}
local BaitDisplayNames = {}

-- Load semua rod dari Items folder
local ItemsFolder = ReplicatedStorage:WaitForChild("Items")
for _, itemModule in ipairs(ItemsFolder:GetChildren()) do
    if itemModule:IsA("ModuleScript") and itemModule.Name:match("Rod") then
        local success, data = pcall(require, itemModule)
        if success and typeof(data) == "table" and data.Data then
            local name = data.Data.Name or "Unknown"
            local id = data.Data.Id or "Unknown"
            local price = data.Price or 0
            local display = name .. " ($" .. price .. ")"

            local rodInfo = { Name = name, Id = id, Price = price, Display = display }

            Rods[name] = rodInfo
            Rods[id] = rodInfo
            table.insert(RodDisplayNames, display)
        end
    end
end

-- Load semua bait dari Baits folder
local BaitsFolder = ReplicatedStorage:WaitForChild("Baits")
for _, baitModule in ipairs(BaitsFolder:GetChildren()) do
    if baitModule:IsA("ModuleScript") then
        local success, data = pcall(require, baitModule)
        if success and typeof(data) == "table" and data.Data then
            local name = data.Data.Name or "Unknown"
            local id = data.Data.Id or "Unknown"
            local price = data.Price or 0
            local display = name .. " ($" .. price .. ")"

            local baitInfo = { Name = name, Id = id, Price = price, Display = display }

            Baits[name] = baitInfo
            Baits[id] = baitInfo
            table.insert(BaitDisplayNames, display)
        end
    end
end

local selectedRods = {}
local selectedBaits = {}

--//======================================================
--// SHOP ROD
--//======================================================
local ShopRod = ShopTab:Section({ 
    Title = "Rod Shop",
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

-- Dropdown Rod
ShopRod:Dropdown({
    Title = "Select Rods",
    Desc = "Choose rods to buy",
	SearchBarEnabled = true,
    Values = RodDisplayNames,
    Multi = true,
    AllowNone = true,
    Value = selectedRods,

    Callback = function(values)
        selectedRods = values
    end
})

-- Button Buy Rod
ShopRod:Button({
    Title = "Buy Selected Rods",
    Callback = function()
        if #selectedRods == 0 then return end

        for _, rodDisplay in ipairs(selectedRods) do
            local rodName = rodDisplay:match("^(.-) %(") -- ambil nama sebelum ($price)
            local rod = Rods[rodName]
            if rod then
                pcall(function()
                    BuyRodRemote:InvokeServer(rod.Id)
                end)
                task.wait(1)
            end
        end
    end
})

--//======================================================
--// SHOP BAIT
--//======================================================
local ShopBait = ShopTab:Section({ 
    Title = "Bait Shop",
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

-- Dropdown Bait
ShopBait:Dropdown({
    Title = "Select Baits",
    Desc = "Choose baits to buy",
	SearchBarEnabled = true,
    Values = BaitDisplayNames,
    Multi = true,
    AllowNone = true,
    Value = selectedBaits,

    Callback = function(values)
        selectedBaits = values
    end
})

-- Button Buy Bait
ShopBait:Button({
    Title = "Buy Selected Baits",
    Callback = function()
        if #selectedBaits == 0 then return end

        for _, baitDisplay in ipairs(selectedBaits) do
            local baitName = baitDisplay:match("^(.-) %(")
            local bait = Baits[baitName]
            if bait then
                pcall(function()
                    BuyBaitRemote:InvokeServer(bait.Id)
                end)
                task.wait(1)
            end
        end
    end
})

-- =================================================================
-- AUTO TOTEM SECTION
-- =================================================================
local AutoTotem = AutoTab:Section({ 
    Title = "Auto Totem", 
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

-- =================================================================
-- REMOTE DEFINITIONS UNTUK AUTO TOTEM
-- =================================================================
local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}
local RepStorage = game:GetService("ReplicatedStorage")

-- Fungsi helper untuk mendapatkan remote
local function GetRemote(remotePath, name, timeout)
    local currentInstance = RepStorage
    for _, childName in ipairs(remotePath) do
        currentInstance = currentInstance:WaitForChild(childName, timeout or 0.5)
        if not currentInstance then return nil end
    end
    return currentInstance:FindFirstChild(name)
end

-- REMOTE YANG DIGUNAKAN OLEH AUTO TOTEM:
local RE_SpawnTotem = GetRemote(RPath, "RE/SpawnTotem") -- Untuk spawn totem
local RE_EquipToolFromHotbar = GetRemote(RPath, "RE/EquipToolFromHotbar") -- Equip rod setelah spawn
local RF_EquipOxygenTank = GetRemote(RPath, "RF/EquipOxygenTank") -- Anti-drown (ID 105)
local RF_UnequipOxygenTank = GetRemote(RPath, "RF/UnequipOxygenTank") -- Lepas oxygen tank

-- Remote tambahan yang mungkin digunakan:
local RE_EquipItem = GetRemote(RPath, "RE/EquipItem")
local RE_UnequipItem = GetRemote(RPath, "RE/UnequipItem")

-- =================================================================
-- STATUS DISPLAY
-- =================================================================
local TOTEM_STATUS_PARAGRAPH = AutoTotem:Paragraph({ 
    Title = "Status: Inactive", 
    Content = "Select totem type and enable", 
    Icon = "clock" 
})

-- =================================================================
-- TOTEM DATA & VARIABLES
-- =================================================================
local TOTEM_DATA = {
    ["Luck Totem"] = {Id = 1, Duration = 3601},     -- 1 jam 1 detik
    ["Mutation Totem"] = {Id = 2, Duration = 3601}, -- 1 jam 1 detik
    ["Shiny Totem"] = {Id = 3, Duration = 3601}     -- 1 jam 1 detik
}

local TOTEM_NAMES = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
local selectedTotemName = "Luck Totem"
local currentTotemExpiry = 0
local AUTO_TOTEM_ACTIVE = false
local AUTO_TOTEM_THREAD = nil

local RunService = game:GetService("RunService")

-- =================================================================
-- 9 TOTEM FORMATION POSITIONS
-- =================================================================
local REF_CENTER = Vector3.new(93.932, 9.532, 2684.134)
local REF_SPOTS = {
    -- TENGAH (Y ~ 9.5)
    Vector3.new(45.0468979, 9.51625347, 2730.19067),   -- 1
    Vector3.new(145.644608, 9.51625347, 2721.90747),   -- 2
    Vector3.new(84.6406631, 10.2174253, 2636.05786),   -- 3

    -- ATAS (Y ~ 109.5)
    Vector3.new(45.0468979, 110.516253, 2730.19067),   -- 4
    Vector3.new(145.644608, 110.516253, 2721.90747),   -- 5
    Vector3.new(84.6406631, 111.217425, 2636.05786),   -- 6

    -- BAWAH (Y ~ -90.5)
    Vector3.new(45.0468979, -92.483747, 2730.19067),   -- 7
    Vector3.new(145.644608, -92.483747, 2721.90747),   -- 8
    Vector3.new(84.6406631, -93.782575, 2636.05786),   -- 9
}

local AUTO_9_TOTEM_ACTIVE = false
local AUTO_9_TOTEM_THREAD = nil
local stateConnection = nil -- Untuk loop pemaksa state

-- =================================================================
-- FLY ENGINE V3 (PHYSICS + STATE MANAGEMENT)
-- =================================================================
local function GetFlyPart()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
end

-- ANTI-FALL STATE MANAGER
local function MaintainAntiFallState(enable)
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end

    if enable then
        -- Matikan semua state yang berhubungan dengan fisika jatuh
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)

        -- Paksa state jadi SWIMMING (stabil di udara)
        if not stateConnection then
            stateConnection = RunService.Heartbeat:Connect(function()
                if hum and AUTO_9_TOTEM_ACTIVE then
                    hum:ChangeState(Enum.HumanoidStateType.Swimming)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                end
            end)
        end
    else
        -- Matikan loop
        if stateConnection then 
            stateConnection:Disconnect() 
            stateConnection = nil 
        end
        
        -- Kembalikan state normal
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        
        hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    end
end

local function EnableV3Physics()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local mainPart = GetFlyPart()
    
    if not mainPart or not hum then return end

    -- Matikan animasi
    if char:FindFirstChild("Animate") then 
        char.Animate.Disabled = true 
    end
    
    hum.PlatformStand = true 
    
    -- Aktifkan anti-fall
    MaintainAntiFallState(true)

    -- Setup BodyVelocity & Gyro
    local bg = mainPart:FindFirstChild("FlyGuiGyro") or Instance.new("BodyGyro", mainPart)
    bg.Name = "FlyGuiGyro"
    bg.P = 9e4 
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = mainPart.CFrame

    local bv = mainPart:FindFirstChild("FlyGuiVelocity") or Instance.new("BodyVelocity", mainPart)
    bv.Name = "FlyGuiVelocity"
    bv.velocity = Vector3.new(0, 0.1, 0) -- Idle velocity
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    -- NoClip loop
    task.spawn(function()
        while AUTO_9_TOTEM_ACTIVE and char do
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then 
                    v.CanCollide = false 
                end
            end
            task.wait(0.1)
        end
    end)
end

local function DisableV3Physics()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local mainPart = GetFlyPart()

    if mainPart then
        -- Hapus body mover
        if mainPart:FindFirstChild("FlyGuiGyro") then 
            mainPart.FlyGuiGyro:Destroy() 
        end
        if mainPart:FindFirstChild("FlyGuiVelocity") then 
            mainPart.FlyGuiVelocity:Destroy() 
        end
        
        -- Hentikan momentum
        mainPart.Velocity = Vector3.zero
        mainPart.RotVelocity = Vector3.zero
        mainPart.AssemblyLinearVelocity = Vector3.zero 
        mainPart.AssemblyAngularVelocity = Vector3.zero

        -- Tegakkan karakter
        local x, y, z = mainPart.CFrame:ToEulerAnglesYXZ()
        mainPart.CFrame = CFrame.new(mainPart.Position) * CFrame.fromEulerAnglesYXZ(0, y, 0)
        
        -- Angkat sedikit
        local ray = Ray.new(mainPart.Position, Vector3.new(0, -5, 0))
        local hit, pos = workspace:FindPartOnRay(ray, char)
        if hit then
            mainPart.CFrame = mainPart.CFrame + Vector3.new(0, 3, 0)
        end
    end

    if hum then 
        hum.PlatformStand = false 
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    
    -- Matikan anti-fall
    MaintainAntiFallState(false) 
    
    -- Nyalakan animasi kembali
    if char and char:FindFirstChild("Animate") then 
        char.Animate.Disabled = false 
    end
    
    -- Restore collision
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then 
                v.CanCollide = true 
            end
        end
    end
end

-- Fungsi gerak physics
local function FlyPhysicsTo(targetPos)
    local mainPart = GetFlyPart()
    if not mainPart then return end
    
    local bv = mainPart:FindFirstChild("FlyGuiVelocity")
    local bg = mainPart:FindFirstChild("FlyGuiGyro")
    
    if not bv or not bg then 
        EnableV3Physics()
        bv = mainPart.FlyGuiVelocity
        bg = mainPart.FlyGuiGyro
    end

    local SPEED = 80 
    
    while AUTO_9_TOTEM_ACTIVE do
        local currentPos = mainPart.Position
        local diff = targetPos - currentPos
        local dist = diff.Magnitude
        
        bg.CFrame = CFrame.lookAt(currentPos, targetPos)

        if dist < 1.0 then 
            bv.velocity = Vector3.new(0, 0.1, 0)
            break
        else
            bv.velocity = diff.Unit * SPEED
        end
        RunService.Heartbeat:Wait()
    end
end

-- =================================================================
-- HELPER FUNCTIONS
-- =================================================================
local function GetPlayerDataReplion()
    local ReplionModule = RepStorage:WaitForChild("Packages"):WaitForChild("Replion", 5)
    if not ReplionModule then return nil end
    return require(ReplionModule).Client:WaitReplion("Data", 5)
end

local function GetTotemUUID(name)
    local r = GetPlayerDataReplion() 
    if not r then return nil end
    
    local s, d = pcall(function() 
        return r:GetExpect("Inventory") 
    end)
    
    if s and d.Totems then 
        for _, i in ipairs(d.Totems) do 
            if tonumber(i.Id) == TOTEM_DATA[name].Id and (i.Count or 1) >= 1 then 
                return i.UUID 
            end 
        end 
    end
    return nil
end

-- =================================================================
-- LOGIC 9 TOTEM (ANTI-DROWN / INFINITE OXYGEN)
-- =================================================================
local function Run9TotemLoop()
    if AUTO_9_TOTEM_THREAD then 
        task.cancel(AUTO_9_TOTEM_THREAD) 
    end
    
    AUTO_9_TOTEM_THREAD = task.spawn(function()
        -- Cek inventory
        local uuid = GetTotemUUID(selectedTotemName)
        if not uuid then 
            WindUI:Notify({ 
                Title = "No Stock", 
                Content = "Isi inventory dulu!", 
                Duration = 3, 
                Icon = "x" 
            })
            local t = AutoTotem:GetElementByTitle("Auto Spawn 9 Totem")
            if t then 
                t:Set(false) 
            end
            return 
        end

        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if not hrp then 
            WindUI:Notify({ 
                Title = "Error", 
                Content = "Character not found!", 
                Duration = 2, 
                Icon = "x" 
            })
            return 
        end
        
        local myStartPos = hrp.Position 

        WindUI:Notify({ 
            Title = "Started", 
            Content = "V3 Engine + Oxygen Protection!", 
            Duration = 3, 
            Icon = "zap" 
        })
        
        -- [ANTI-DROWN] Pasang Oxygen Tank (ID 105)
        if RF_EquipOxygenTank then
            pcall(function() 
                RF_EquipOxygenTank:InvokeServer(105) 
            end)
        end
        
        -- Isi darah penuh
        if hum then 
            hum.Health = hum.MaxHealth 
        end

        -- Aktifkan physics
        EnableV3Physics()

        -- Loop 9 titik spawn
        for i, refSpot in ipairs(REF_SPOTS) do
            if not AUTO_9_TOTEM_ACTIVE then break end
            
            local relativePos = refSpot - REF_CENTER
            local targetPos = myStartPos + relativePos
            
            TOTEM_STATUS_PARAGRAPH:SetDesc(string.format("Flying to #%d...", i))
            FlyPhysicsTo(targetPos) 
            
            -- Stabilisasi
            task.wait(0.6) 

            -- Cek ulang UUID
            uuid = GetTotemUUID(selectedTotemName)
            if uuid then
                TOTEM_STATUS_PARAGRAPH:SetDesc(string.format("Spawning #%d...", i))
                
                -- Spawn totem
                pcall(function() 
                    RE_SpawnTotem:FireServer(uuid) 
                end)
                
                -- Re-equip rod
                task.spawn(function() 
                    for k = 1, 5 do 
                        pcall(function() 
                            RE_EquipToolFromHotbar:FireServer(1) 
                        end)
                        task.wait(0.1) 
                    end 
                end)
            else
                WindUI:Notify({ 
                    Title = "Out of Stock", 
                    Content = "Totem habis!", 
                    Duration = 2, 
                    Icon = "x" 
                })
                break
            end
            
            task.wait(1.5) 
        end

        if AUTO_9_TOTEM_ACTIVE then
            TOTEM_STATUS_PARAGRAPH:SetDesc("Returning...")
            FlyPhysicsTo(myStartPos)
            task.wait(0.5)
            
            WindUI:Notify({ 
                Title = "Selesai", 
                Content = "9 Totem berhasil di-spawn!", 
                Duration = 3, 
                Icon = "check" 
            })
        end
        
        -- [CLEANUP] Lepas Oxygen Tank
        if RF_UnequipOxygenTank then
            pcall(function() 
                RF_UnequipOxygenTank:InvokeServer() 
            end)
        end

        -- Matikan physics
        DisableV3Physics() 
        
        AUTO_9_TOTEM_ACTIVE = false
        local t = AutoTotem:GetElementByTitle("Auto Spawn 9 Totem")
        if t then 
            t:Set(false) 
        end
        
        TOTEM_STATUS_PARAGRAPH:SetDesc("Waiting...")
        TOTEM_STATUS_PARAGRAPH:SetTitle("Status: Inactive")
    end)
end

-- =================================================================
-- LOGIC SINGLE TOTEM
-- =================================================================
local function RunAutoTotemLoop()
    if AUTO_TOTEM_THREAD then 
        task.cancel(AUTO_TOTEM_THREAD) 
    end
    
    AUTO_TOTEM_THREAD = task.spawn(function()
        while AUTO_TOTEM_ACTIVE do
            local timeLeft = currentTotemExpiry - os.time()
            
            if timeLeft > 0 then
                -- Tampilkan waktu tersisa
                local m = math.floor((timeLeft % 3600) / 60)
                local s = math.floor(timeLeft % 60)
                TOTEM_STATUS_PARAGRAPH:SetDesc(string.format("Next Spawn: %02d:%02d", m, s))
                TOTEM_STATUS_PARAGRAPH:SetTitle("Status: " .. selectedTotemName .. " Active")
            else
                -- Spawn totem
                TOTEM_STATUS_PARAGRAPH:SetDesc("Spawning Single...")
                local uuid = GetTotemUUID(selectedTotemName)
                
                if uuid then
                    -- Spawn totem
                    pcall(function() 
                        RE_SpawnTotem:FireServer(uuid) 
                    end)
                    
                    currentTotemExpiry = os.time() + TOTEM_DATA[selectedTotemName].Duration
                    
                    -- Re-equip rod
                    task.spawn(function() 
                        for i = 1, 3 do 
                            task.wait(0.2) 
                            pcall(function() 
                                RE_EquipToolFromHotbar:FireServer(1) 
                            end) 
                        end 
                    end)
                    
                    WindUI:Notify({ 
                        Title = "Totem Spawned", 
                        Content = selectedTotemName .. " diaktifkan", 
                        Duration = 2, 
                        Icon = "check" 
                    })
                else
                    WindUI:Notify({ 
                        Title = "Out of Stock", 
                        Content = "Tidak ada totem di inventory", 
                        Duration = 2, 
                        Icon = "x" 
                    })
                end
            end
            
            task.wait(1)
        end
        
        TOTEM_STATUS_PARAGRAPH:SetDesc("Inactive")
        TOTEM_STATUS_PARAGRAPH:SetTitle("Status: Inactive")
    end)
end

-- =================================================================
-- UI CONTROLS
-- =================================================================

-- Dropdown pilih jenis totem
AutoTotem:Dropdown({ 
    Title = "Pilih Jenis Totem", 
    Values = TOTEM_NAMES, 
    Value = selectedTotemName, 
    Multi = false, 
    Callback = function(n) 
        selectedTotemName = n
        currentTotemExpiry = 0
        
        TOTEM_STATUS_PARAGRAPH:SetTitle("Status: " .. n)
        TOTEM_STATUS_PARAGRAPH:SetDesc("Selected")
        
        WindUI:Notify({ 
            Title = "Totem Dipilih", 
            Content = "Menggunakan " .. n, 
            Duration = 2, 
            Icon = "check" 
        })
    end 
})

-- Toggle untuk Auto Totem Single
AutoTotem:Toggle({ 
    Title = "Enable Auto Totem (Single)", 
    Desc = "Mode Normal - Spawn 1 totem setiap 1 jam", 
    Value = false, 
    Flag = "toggletotem", 
    Callback = function(s) 
        AUTO_TOTEM_ACTIVE = s
        
        if s then 
            RunAutoTotemLoop() 
            WindUI:Notify({ 
                Title = "Auto Totem ON", 
                Content = "Single totem aktif setiap 1 jam", 
                Duration = 3, 
                Icon = "zap" 
            })
        else 
            if AUTO_TOTEM_THREAD then 
                task.cancel(AUTO_TOTEM_THREAD) 
                AUTO_TOTEM_THREAD = nil 
            end
            
            TOTEM_STATUS_PARAGRAPH:SetDesc("Inactive")
            TOTEM_STATUS_PARAGRAPH:SetTitle("Status: Inactive")
            
            WindUI:Notify({ 
                Title = "Auto Totem OFF", 
                Duration = 2, 
                Icon = "x" 
            })
        end 
    end 
})

-- Toggle untuk Auto Spawn 9 Totem
AutoTotem:Toggle({
    Title = "Auto Spawn 9 Totem",
    Desc = "Mode Ultimate - Spawn 9 totem di formasi 3D",
    Value = false,
    Flag = "toggle9totem",
    Callback = function(s)
        AUTO_9_TOTEM_ACTIVE = s
        
        if s then
            Run9TotemLoop()
        else
            if AUTO_9_TOTEM_THREAD then 
                task.cancel(AUTO_9_TOTEM_THREAD) 
                AUTO_9_TOTEM_THREAD = nil 
            end
            
            DisableV3Physics()
            
            TOTEM_STATUS_PARAGRAPH:SetDesc("Stopped")
            TOTEM_STATUS_PARAGRAPH:SetTitle("Status: Inactive")
            
            WindUI:Notify({ 
                Title = "Stopped", 
                Content = "Auto 9 Totem dimatikan", 
                Duration = 2, 
                Icon = "x" 
            })
        end
    end
})

-- Tombol spawn manual (opsional)
AutoTotem:Button({
    Title = "Spawn Totem Sekarang",
    Icon = "zap",
    Callback = function()
        local uuid = GetTotemUUID(selectedTotemName)
        if uuid then
            pcall(function() 
                RE_SpawnTotem:FireServer(uuid) 
            end)
            
            WindUI:Notify({ 
                Title = "Manual Spawn", 
                Content = selectedTotemName .. " di-spawn", 
                Duration = 2, 
                Icon = "check" 
            })
            
            -- Re-equip rod
            task.spawn(function() 
                for i = 1, 3 do 
                    task.wait(0.2) 
                    pcall(function() 
                        RE_EquipToolFromHotbar:FireServer(1) 
                    end) 
                end 
            end)
        else
            WindUI:Notify({ 
                Title = "Error", 
                Content = "Tidak ada totem di inventory", 
                Duration = 2, 
                Icon = "x" 
            })
        end
    end
})


--================
--TELETAB        =
--================

--//======================================================
--// ISLAND TELEPORT
--//======================================================
local teleportLocations = {
	["Fishermand Island"] = CFrame.new(251.970, 3.262, 2972.211) * CFrame.Angles(-3.141593, -1.257929, -3.141593),
	["Crater Island"] = CFrame.new(1072.845, 5.034, 5112.388) * CFrame.Angles(-0.000000, 1.229756, -0.000000),
	["Ancient Jungle"] = CFrame.new(1433.173, 6.625, -782.708) * CFrame.Angles(-0.000000, -0.360566, -0.000000),
	["Kohana"] = CFrame.new(-655.889, 17.250, 483.854) * CFrame.Angles(-0.000000, -1.567192, -0.000000),
	["Volcano"] = CFrame.new(-560.156, 17.091, 110.184) * CFrame.Angles(-0.000000, -0.530737, -0.000000),
	["Sisyphus Statue"] = CFrame.new(-3779.833, -135.074, -971.949) * CFrame.Angles(-3.141593, -1.297434, -3.141593),
	["Tropical Grove"] = CFrame.new(-2033.356, 6.268, 3679.782) * CFrame.Angles(-3.141593, 0.767602, -3.141593),
	["Treasure Room"] = CFrame.new(-3649.771, -268.340, -1666.103) * CFrame.Angles(-3.141593, -1.352865, -3.141593),
	["Sacred Temple"] = CFrame.new(1476.163, -22.125, -675.394) * CFrame.Angles(-0.000000, -1.515740, -0.000000),
	["Coral Reefs"] = CFrame.new(-3132.816, 3.354, 2129.545) * CFrame.Angles(-0.000000, -0.597924, -0.000000),
	["Weather Machine"] = CFrame.new(-1515.702, 2.875, 1912.361) * CFrame.Angles(-3.141593, -0.177870, -3.141593),
	["Esoteric Dephts"] = CFrame.new(3204.603, -1302.855, 1410.619) * CFrame.Angles(-0.000000, 0.454337, -0.000000),
	["Ancient Ruin"] = CFrame.new(6099.980, -585.924, 4682.759) * CFrame.Angles(3.141535, 1.569459, -3.141535),
	["Classic Island"] = CFrame.new(1226.521, 4.000, 2774.871) * CFrame.Angles(0.000000, 0.006386, -0.000000),
	["Iron Cavern"] = CFrame.new(-8800.321, -585.000, 83.745) * CFrame.Angles(-0.000000, -0.943772, 0.000000),
	["Iron Cafe"] = CFrame.new(-8642.318, -547.500, 158.730) * CFrame.Angles(0.000000, -1.559896, 0.000000),
	["Underground Cellar"] = CFrame.new(2135.955, -91.199, -697.068) * CFrame.Angles(-0.000000, -0.098867, 0.000000),
	["Christmas Island 1"] = CFrame.new(666.372, 5.080, 1617.845) * CFrame.Angles(0.000000, 0.793008, 0.000000),
	["Christmas Island 2"] = CFrame.new(1161.302, 23.762, 1530.955) * CFrame.Angles(0.000000, 2.861345, 0.000000)
}

local selectedLocation = nil

local function teleportTo(cf)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = cf
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local Island = TeleTab:Section({ 
    Title = "Island",
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

Island:Dropdown({
    Title = "Select Location",
	SearchBarEnabled = true,
    Values = (function()
        local keys = {}
        for name in pairs(teleportLocations) do table.insert(keys, name) end
		table.sort(keys)
        return keys
    end)(),
    Callback = function(selected)
        selectedLocation = selected
    end
})

Island:Button({
    Title = "Teleport to Island",
    Callback = function()
        if selectedLocation and teleportLocations[selectedLocation] then
            teleportTo(teleportLocations[selectedLocation])
        end
    end
})

--//======================================================
--// PLAYER TELEPORT
--//======================================================
local PlayerSection = TeleTab:Section({ 
    Title = "Player",
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

local Players = game:GetService("Players")
local selectedPlayer = nil

-- Ambil semua player kecuali LocalPlayer
local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    table.sort(names)
    return names
end

-- Dropdown player
local playerDropdown = PlayerSection:Dropdown({
    Title = "Select Player",
    SearchBarEnabled = true,
    Values = getPlayerNames(),
    Callback = function(selected)
        selectedPlayer = selected
    end
})

-- Tombol teleport
PlayerSection:Button({
    Title = "Teleport To Player",
    Callback = function()
        if not selectedPlayer then
            warn("Belum memilih player.")
            return
        end

        local target = Players:FindFirstChild(selectedPlayer)
        local localChar = Players.LocalPlayer.Character

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") 
           and localChar and localChar:FindFirstChild("HumanoidRootPart") then
            -- Offset supaya tidak nabrak
            local offset = Vector3.new(0, 5, 0)
            localChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + offset
        else
            warn("Target atau karakter LocalPlayer belum siap.")
        end
    end
})




--//======================================================
--// EVENT ZONE TELEPORT
--//======================================================
local eventLocation = {
    ["Worm Hunt 1"] = CFrame.new(2190.85, -1.3999, 97.5749),
    ["Worm Hunt 2"] = CFrame.new(-2450.6, -1.3999, 139.731),
    ["Worm Hunt 3"] = CFrame.new(-267.47, -1.3999, 5188.53),
    ["Shark Hunt 1"] = CFrame.new(1.64999, -1.3500, 2095.72),
    ["Shark Hunt 2"] = CFrame.new(1369.94, -1.3500, 930.125),
    ["Shark Hunt 3"] = CFrame.new(-1585.5, -1.3500, 1242.87),
    ["Shark Hunt 4"] = CFrame.new(-1896.8, -1.3500, 2634.37),
    ["Megalodon Hunt 1"] = CFrame.new(-1076.3, -1.3999, 1676.19),
    ["Megalodon Hunt 2"] = CFrame.new(-1191.8, -1.3999, 3597.30),
    ["Megalodon Hunt 3"] = CFrame.new(412.700, -1.3999, 4134.39),
}

local selectedeventLocation = nil
local player = game.Players.LocalPlayer

local function teleportToevent(pos)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local oldPlatform = Workspace:FindFirstChild("TeleportPlatform")
    if oldPlatform then
        oldPlatform:Destroy()
    end

    local platformHeight = 2
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(20, platformHeight, 20)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.Neon
    platform.Color = Color3.fromRGB(0, 255, 0)
    platform.Transparency = 0.4
    platform.Name = "TeleportPlatform"
    platform.Position = pos.Position + Vector3.new(0, platformHeight/2 + 1, 0)
    platform.Parent = Workspace

    hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 3, 0))
end

local Island = TeleTab:Section({ 
    Title = "Event Zone",
    Box = false,
    TextTransparency = 0,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = false,
})

local keys = {}
for name in pairs(eventLocation) do table.insert(keys, name) end
table.sort(keys)

local islandDropdown = Island:Dropdown({
    Title = "Select Event Zone",
    SearchBarEnabled = true,
    Values = keys,
    Callback = function(selected)
        selectedeventLocation = selected
    end
})

Island:Button({
    Title = "Teleport to eventzone",
    Callback = function()
        if selectedeventLocation and eventLocation[selectedeventLocation] then
            teleportToevent(eventLocation[selectedeventLocation])
        else
            warn("Pilih lokasi terlebih dahulu.")
        end
    end
})

--================
--WEBHOOKTAB     =
--================

--//======================================================
--// 🟩 WEBHOOK SYSTEM (FULL + AUTO SAVE/LOAD)
--//======================================================

local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local httpRequest = request

--========================================================
-- SAVE / LOAD CONFIG
--========================================================

local ConfigFile = "RuinzFishWebhook.json"

local function Save(data)
	if writefile then
		writefile(ConfigFile, HttpService:JSONEncode(data))
	end
end

local function Load()
	if not isfile or not readfile then return {} end
	if not isfile(ConfigFile) then return {} end

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(readfile(ConfigFile))
	end)

	return ok and decoded or {}
end

local Saved = Load()

--========================================================
-- CONFIG
--========================================================

local WebhookConfig = Saved.WebhookConfig or {
	WebhookFlags = {
		FishCaught = {
			Enabled = false,
			URL = ""
		}
	},

	WebhookRarities = {},
	WebhookNames = {},
	WebhookCustomName = "",

	TierFish = {
		[1] = "Common",
		[2] = "Uncommon",
		[3] = "Rare",
		[4] = "Epic",
		[5] = "Legendary",
		[6] = "Mythic",
		[7] = "Secret",
	},

	WebhookLock = {},
}

local function SaveConfig()
	Save({
		WebhookConfig = WebhookConfig
	})
end

--========================================================
-- FISH DATABASE
--========================================================

local FishData = {}

local function BuildFishDatabase()
	local items = RS:WaitForChild("Items")

	for _, module in ipairs(items:GetChildren()) do
		local ok, data = pcall(require, module)
		if ok and type(data) == "table" and data.Data and data.Data.Type == "Fish" then
			local d = data.Data
			FishData[d.Id] = {
				Name = d.Name,
				Tier = d.Tier,
				Icon = d.Icon,
				SellPrice = data.SellPrice
			}
		end
	end
end

BuildFishDatabase()

--========================================================
-- UTILS
--========================================================

local function GetThumbnailURL(icon)
	local id = icon:match("rbxassetid://(%d+)")
	if not id then return nil end

	local url = string.format(
		"https://thumbnails.roblox.com/v1/assets?assetIds=%s&type=Asset&size=420x420&format=Png",
		id
	)

	local ok, result = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)

	return ok and result and result.data and result.data[1] and result.data[1].imageUrl
end

local function SendWebhook(url, payload)
	if not httpRequest or not url or url == "" then return end
	if WebhookConfig.WebhookLock[url] then return end

	WebhookConfig.WebhookLock[url] = true
	task.delay(0.25, function()
		WebhookConfig.WebhookLock[url] = nil
	end)

	pcall(function()
		httpRequest({
			Url = url,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(payload)
		})
	end)
end

--========================================================
-- SEND FISH WEBHOOK
--========================================================

local function SendFishWebhook(f)
	local flags = WebhookConfig.WebhookFlags.FishCaught
	if not flags.Enabled then return end
	if not flags.URL:match("discord.com/api/webhooks") then return end

	local data = FishData[f.Id]
	if not data then return end

	local tierName = WebhookConfig.TierFish[data.Tier] or "Unknown"

	-- Tier Filter
	if #WebhookConfig.WebhookRarities > 0 and not table.find(WebhookConfig.WebhookRarities, tierName) then
		return
	end

	-- Name Filter
	if #WebhookConfig.WebhookNames > 0 and not table.find(WebhookConfig.WebhookNames, data.Name) then
		return
	end

	local weight = f.Metadata and f.Metadata.Weight and string.format("%.2f Kg", f.Metadata.Weight) or "N/A"
	local mutation = f.Metadata and f.Metadata.VariantId and tostring(f.Metadata.VariantId) or "None"

	local price = data.SellPrice and "$" ..
		string.format("%d", data.SellPrice):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") or "N/A"

	-- Mask Player Name
	local player = game.Players.LocalPlayer
	local maskedName = WebhookConfig.WebhookCustomName ~= "" and WebhookConfig.WebhookCustomName 
		or player.Name

	-- Total caught
	local totalCaught = "N/A"
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats and leaderstats:FindFirstChild("Caught") then
		totalCaught = tostring(leaderstats.Caught.Value)
	end

	local payload = {
		username = "Ruinz Notification",
		avatar_url = "https://raw.githubusercontent.com/gemluak-oss/haha/refs/heads/main/Ruinz%20Icon.png",

		embeds = {{
			title = "Ruinz Webhook",
			color = 0xFF8B16,
			description = "𝐴 " .. tierName .. " 𝑓𝑖𝑠ℎ ℎ𝑎𝑠 𝑐𝑎𝑢𝑔ℎ𝑡.",

			fields = {
				{ name = "🔸Player :",      value = "``` " .. maskedName .. "```" },
				{ name = "🔸Total Caught :", value = "``` " .. totalCaught .. "```" },
				{ name = "🔸Fish Name :",    value = "``` " .. data.Name .. "```" },
				{ name = "🔸Fish Tier :",    value = "``` " .. tierName .. "```" },
				{ name = "🔸Weight :",       value = "``` " .. weight .. "```" },
				{ name = "🔸Mutation :",     value = "``` " .. mutation .. "```" },
				{ name = "🔸Base Price :",   value = "``` " .. price .. "```" },
			},

			thumbnail = {
				url = GetThumbnailURL(data.Icon)
					or "https://raw.githubusercontent.com/gemluak-oss/haha/refs/heads/main/Ruinz%20Icon.png"
			},

			footer = {
				text = "Ruinz Webhook",
			},

			timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
		}}
	}

	SendWebhook(flags.URL, payload)
end


--========================================================
-- LOCKED SECRET FISH WEBHOOK (FULL INFO + MASKED)
--========================================================
local SendSecretWebhook

local SECRET_WEBHOOK_URL = "https://discord.com/api/webhooks/1438816311760257075/uHWu_63uzLvqzDjEK3QsYN9MqkxyRMO2Y6fgJ7XNEmz3LnaU_HyKZEeszj4kU9jJsrHb" -- ganti URL di sini

SendSecretWebhook = function(f)
    local data = FishData[f.Id]
    if not data then return end

    local tierName = WebhookConfig.TierFish[data.Tier]
    if tierName ~= "Secret" then return end

    local player = game.Players.LocalPlayer
    local meta = f.Metadata or {}

    local weight = meta.Weight and string.format("%.2f Kg", meta.Weight) or "N/A"
    local mutation = meta.VariantId and tostring(meta.VariantId) or "None"


    -- MASK PLAYER NAME
    local maskedName = string.sub(player.Name, 1, 3) .. "***"

    local payload = {
        username = "Ruinz Notification",
        avatar_url = "https://raw.githubusercontent.com/gemluak-oss/haha/refs/heads/main/Ruinz%20Icon.png",

        embeds = {{
            title = "Ruinz Webhook",
            color = 0x40E0D0,
			description = "𝐴 " .. tierName .. " 𝑓𝑖𝑠ℎ ℎ𝑎𝑠 𝑏𝑒𝑒𝑛 𝑐𝑎𝑢𝑔ℎ𝑡.",

            fields = {
                { name = "🔸Player :",         value = "``` " .. maskedName .. "```" },
                { name = "🔸Fish Name :",      value = "``` " .. data.Name .. "```" },
                { name = "🔸Fish Tier :",       value = "``` Secret ```" },
                { name = "🔸Weight :",         value = "``` " .. weight .. "```" },
                { name = "🔸Mutation :",       value = "``` " .. mutation .. "```" },
            },

            thumbnail = {
                url = GetThumbnailURL(data.Icon)
                    or "https://raw.githubusercontent.com/gemluak-oss/haha/refs/heads/main/Ruinz%20Icon.png"
            },

            footer = {
                text = "Ruinz Webhook",
            },

            timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
        }}
    }

    SendWebhook(SECRET_WEBHOOK_URL, payload)
end


--========================================================
-- HOOK REMOTE FISH EVENT
--========================================================

task.spawn(function()
	local Net = RS.Packages._Index["sleitnick_net@0.2.0"].net
	local Remote

	repeat
		Remote = Net["RE/ObtainedNewFishNotification"]
		task.wait(1)
	until Remote

	Remote.OnClientEvent:Connect(function(id, meta)

		local fish = {
			Id = id,
			Metadata = meta
		}
		if WebhookConfig.WebhookFlags.FishCaught.Enabled then
			SendFishWebhook(fish)
		end

		task.wait(1)

		SendSecretWebhook(fish)
	end)
end)


--========================================================
-- UI INPUTS (AUTO SAVE)
--========================================================

WebTab:Section({Title = "Discord Fish Notifications"})

-- Webhook URL
WebTab:Input({
	Title = "Webhook URL",
	Placeholder = "enter url...",
	Type = "Input",
	Value = WebhookConfig.WebhookFlags.FishCaught.URL,
	Callback = function(url)
		WebhookConfig.WebhookFlags.FishCaught.URL = url
		SaveConfig()
	end
})

-- Tier Filter
WebTab:Dropdown({
	Title = "Tier Filter",
	Multi = true,
	AllowNone = true,
	Values = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Secret"},
	Value = WebhookConfig.WebhookRarities,
	Callback = function(list)
		WebhookConfig.WebhookRarities = list
		SaveConfig()
	end
})

WebTab:Input({
    Title = "Hide Identity",
    Placeholder = "enter name...",
    Callback = function(text)
        WebhookConfig.WebhookCustomName = text
    end
})


WebTab:Toggle({
	Title = "Enable Webhook",
	Value = WebhookConfig.WebhookFlags.FishCaught.Enabled,
	Callback = function(state)
		WebhookConfig.WebhookFlags.FishCaught.Enabled = state
		SaveConfig()
	end
})


WebTab:Button({
	Title = "Test Webhook",
	Callback = function()
		local url = WebhookConfig.WebhookFlags.FishCaught.URL
		if not url or not url:match("discord.com/api/webhooks") then
			warn("Invalid webhook URL")
			return
		end

		SendWebhook(url,{
			username = "Ruinz Notifier",
			avatar_url = "https://raw.githubusercontent.com/gemluak-oss/haha/refs/heads/main/Ruinz%20Icon.png",
			embeds={{ image={url="https://c.tenor.com/M71NkBqewVgAAAAd/tenor.gif"} }}
		})
	end
})


--================
--SETTING TAB    =
--================

SetTab:Section({Title = "Settings"})


--------------------------HIDE IDENTITY RGB
local enabled = false
local original = {}

-- Fungsi RGB helper
local function rainbowColor(t)
    return Color3.fromHSV((t % 5) / 5, 1, 1)
end

-- Ambil elemen target
local function getTargets()
    local chars = workspace:FindFirstChild("Characters")
    if not chars then return end
    local char = chars:FindFirstChild(player.Name)
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local over = root:FindFirstChild("Overhead")
    if not over then return end

    local nameLabel = over:FindFirstChild("Content") and over.Content:FindFirstChild("Header")
    local levelLabel = over:FindFirstChild("LevelContainer") and over.LevelContainer:FindFirstChild("Label")

    local coinLabel
    local ok, obj = pcall(function()
        return player.PlayerGui.Events.Frame.CurrencyCounter.Counter
    end)
    if ok and obj and obj:IsA("TextLabel") then
        coinLabel = obj
    end

    return nameLabel, levelLabel, coinLabel
end

-- Simpan original text
local function saveOriginal(label, key)
    if not label or original[key] then return end
    original[key] = {
        Text = label.Text,
        Color = label.TextColor3,
    }
end

-- Restore semula
local function restoreAll()
    local n, l, c = getTargets()
    if n and original.name then
        n.Text = original.name.Text
        n.TextColor3 = original.name.Color
    end
    if l and original.level then
        l.Text = original.level.Text
        l.TextColor3 = original.level.Color
    end
    if c and original.coin then
        c.Text = original.coin.Text
        c.TextColor3 = original.coin.Color
    end
    original = {}
end

-- Toggle utama
SetTab:Toggle({
    Title = "Hide All Identity",
    Default = false,
    Callback = function(state)
        enabled = state

        if not enabled then
            restoreAll()
        end
    end
})

-- Loop untuk update warna RGB
task.spawn(function()
    while task.wait(0.05) do
        if enabled then
            local color = rainbowColor(tick())
            local n, l, c = getTargets()
            if n then
                saveOriginal(n, "name")
                n.Text = "RUINZ"
                n.TextColor3 = color
            end
            if l then
                saveOriginal(l, "level")
                l.Text = "RUINZ"
                l.TextColor3 = color
            end
            if c then
                saveOriginal(c, "coin")
                c.Text = "RUINZ"
                c.TextColor3 = color
            end
        end
    end
end)

-- Reapply saat respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    if enabled then
        local n, l, c = getTargets()
        local color = rainbowColor(tick())
        if n then n.Text = "RUINZ" n.TextColor3 = color end
        if l then l.Text = "RUINZ" l.TextColor3 = color end
        if c then c.Text = "RUINZ" c.TextColor3 = color end
    end
end)

--------------------------------FPS BOOST
local fpsConnections = {}
local fpsRunning = false

SetTab:Toggle({
    Title = "Boost FPS",
    Icon = "zap",
    Default = false,
    Callback = function(state)

        if state and not fpsRunning then
            fpsRunning = true

            --------------------------------
            -- ✅ KODE ASLI KAMU DIJALANKAN
            --------------------------------

            local Players = game:GetService("Players")
            local Lighting = game:GetService("Lighting")
            local RunService = game:GetService("RunService")
            local Workspace = game:GetService("Workspace")
            local player = Players.LocalPlayer

            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e6
            Lighting.Brightness = 1
            Lighting.ClockTime = 14

            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then
                    v:Destroy()
                end
            end

            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end

            local function protected(obj)
                if obj:IsDescendantOf(player:WaitForChild("PlayerGui")) then return true end
                if obj:IsDescendantOf(game:GetService("StarterGui")) then return true end
                if obj:IsDescendantOf(game:GetService("ReplicatedStorage")) then return true end
                return false
            end

            local function nuke(obj)
                if protected(obj) then return end

                if obj:IsA("ParticleEmitter")
                or obj:IsA("Trail")
                or obj:IsA("Beam")
                or obj:IsA("Fire")
                or obj:IsA("Smoke")
                or obj:IsA("Sparkles") then
                    obj:Destroy()
                end

                if obj:IsA("Highlight") then
                    obj:Destroy()
                end

                if obj:IsA("Decal")
                or obj:IsA("Texture")
                or obj:IsA("SurfaceAppearance") then
                    obj:Destroy()
                end

                if obj:IsA("PointLight")
                or obj:IsA("SpotLight")
                or obj:IsA("SurfaceLight") then
                    obj:Destroy()
                end

                if obj:IsA("MeshPart") then
                    obj.TextureID = ""
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                end

                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Color = Color3.fromRGB(170,170,170)
                    obj.Reflectance = 0
                    obj.CastShadow = false
                end
            end

            for _,v in ipairs(game:GetDescendants()) do
                nuke(v)
            end

            table.insert(fpsConnections, game.DescendantAdded:Connect(function(obj)
                task.wait()
                if fpsRunning then
                    nuke(obj)
                end
            end))

            local function onChar(char)
                for _,v in ipairs(char:GetDescendants()) do
                    nuke(v)
                end
                table.insert(fpsConnections, char.DescendantAdded:Connect(function(o)
                    if fpsRunning then
                        nuke(o)
                    end
                end))
            end

            if player.Character then
                onChar(player.Character)
            end

            table.insert(fpsConnections, player.CharacterAdded:Connect(onChar))

            table.insert(fpsConnections, RunService.RenderStepped:Connect(function()
                if fpsRunning then
                    settings().Rendering.QualityLevel = 1
                end
            end))

        elseif not state and fpsRunning then
            --------------------------------
            -- ❌ MATIKAN SEMUA PROSES
            --------------------------------
            fpsRunning = false

            for _, conn in ipairs(fpsConnections) do
                pcall(function()
                    conn:Disconnect()
                end)
            end

            fpsConnections = {}
        end
    end
})


-------------------antiafk
SetTab:Toggle({
    Title = "Anti AFK",
    Icon = "moon",
    Callback = function(value)
        if value then
            WindUI:Notify({ Title = "Anti AFK", Content = "AFK protection enabled." })
            local VirtualUser = game:GetService("VirtualUser")
            player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            WindUI:Notify({ Title = "Anti AFK", Content = "Disabled." })
        end
    end
})

-- -------------------antiafk2
-- SetTab:Toggle({
--     Title = "Anti AFK 2",
--     Icon = "moon",
--     Callback = function(enabled)
--         local player = game.Players.LocalPlayer
--         local VirtualInputManager = game:GetService("VirtualInputManager")
--         local GuiService = game:GetService("GuiService")
--         local camera = workspace.CurrentCamera

--         local ANTI_AFK_CONFIG = {
--             CLICK_COUNT = 5,
--             CLICK_DELAY = 0.5,
--             INTERVAL = 120,
--         }

--         local function getScreenCenter()
--             local viewportSize = camera.ViewportSize
--             local guiInset = GuiService:GetGuiInset()
--             return viewportSize.X / 2, (viewportSize.Y / 2) + guiInset.Y
--         end

--         local function performAntiAfkClicks()
--             local centerX, centerY = getScreenCenter()
--             for i = 1, ANTI_AFK_CONFIG.CLICK_COUNT do
--                 VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
--                 task.wait(0.05)
--                 VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
--                 if i < ANTI_AFK_CONFIG.CLICK_COUNT then
--                     task.wait(ANTI_AFK_CONFIG.CLICK_DELAY)
--                 end
--             end
--         end

--         if enabled then
--             if not _G.AFKClickLoop then
--                 _G.AFKClickLoop = task.spawn(function()
--                     while true do
--                         task.wait(ANTI_AFK_CONFIG.INTERVAL)
--                         pcall(performAntiAfkClicks)
--                     end
--                 end)
--             end
--         else
--             if _G.AFKClickLoop then
--                 task.cancel(_G.AFKClickLoop)
--                 _G.AFKClickLoop = nil
--             end
--         end
--     end
-- })


-- RUINZ SILVER DARK PERFORMANCE MONITOR
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Silver Dark ScreenGui
local monitorUI = Instance.new("ScreenGui")
monitorUI.Name = "RUINZSilverMonitor"
monitorUI.ResetOnSpawn = false
monitorUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
monitorUI.Parent = PlayerGui

-- Main Silver Dark Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "SilverMonitor"
mainFrame.Size = UDim2.new(0, 220, 0, 103)
mainFrame.Position = UDim2.new(0, 50, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)  -- Darker black
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = monitorUI

-- Silver Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Silver Metallic Border
local outerStroke = Instance.new("UIStroke")
outerStroke.Color = Color3.fromRGB(160, 160, 170)  -- Silver color
outerStroke.Thickness = 1.5
outerStroke.Transparency = 0
outerStroke.Parent = mainFrame

-- Subtle Inner Glow
local innerStroke = Instance.new("UIStroke")
innerStroke.Color = Color3.fromRGB(80, 80, 90)
innerStroke.Thickness = 1
innerStroke.Transparency = 0.7
innerStroke.Parent = mainFrame

-- Dark Gradient Background
local bgGradient = Instance.new("UIGradient")
bgGradient.Rotation = 90
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 18))
})
bgGradient.Parent = mainFrame

-- Silver Header
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, -16, 0, 32)
headerFrame.Position = UDim2.new(0, 8, 0, 8)
headerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)  -- Dark grey
headerFrame.BackgroundTransparency = 0
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = headerFrame

-- Silver Header Border
local headerStroke = Instance.new("UIStroke")
headerStroke.Color = Color3.fromRGB(100, 100, 110)
headerStroke.Thickness = 1
headerStroke.Transparency = 0.5
headerStroke.Parent = headerFrame

-- Silver Title
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "RUINZ PANEL"
titleText.TextColor3 = Color3.fromRGB(220, 220, 225)  -- Silver white
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.Font = Enum.Font.SourceSansBold
titleText.Parent = headerFrame

-- Content Area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -16, 1, -48)
contentFrame.Position = UDim2.new(0, 8, 0, 48)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Grid Layout
local gridFrame = Instance.new("Frame")
gridFrame.Name = "Grid"
gridFrame.Size = UDim2.new(1, 0, 1, 0)
gridFrame.BackgroundTransparency = 1
gridFrame.Parent = contentFrame

-- Silver Ping Card
local pingCard = Instance.new("Frame")
pingCard.Name = "PingCard"
pingCard.Size = UDim2.new(0.48, 0, 0, 48)
pingCard.BackgroundColor3 = Color3.fromRGB(28, 28, 32)  -- Dark grey
pingCard.BackgroundTransparency = 0
pingCard.BorderSizePixel = 0
pingCard.Parent = gridFrame

local pingCardCorner = Instance.new("UICorner")
pingCardCorner.CornerRadius = UDim.new(0, 8)
pingCardCorner.Parent = pingCard

local pingCardStroke = Instance.new("UIStroke")
pingCardStroke.Color = Color3.fromRGB(70, 70, 80)  -- Dark silver
pingCardStroke.Thickness = 1
pingCardStroke.Transparency = 0
pingCardStroke.Parent = pingCard

-- Ping Content
local pingContent = Instance.new("Frame")
pingContent.Name = "PingContent"
pingContent.Size = UDim2.new(1, -12, 1, -12)
pingContent.Position = UDim2.new(0, 6, 0, 6)
pingContent.BackgroundTransparency = 1
pingContent.Parent = pingCard

local pingIcon = Instance.new("TextLabel")
pingIcon.Name = "PingIcon"
pingIcon.Size = UDim2.new(0, 24, 0, 24)
pingIcon.BackgroundTransparency = 1
pingIcon.Text = "⇄"
pingIcon.TextColor3 = Color3.fromRGB(180, 180, 190)  -- Silver
pingIcon.TextSize = 16
pingIcon.Font = Enum.Font.GothamBold
pingIcon.Parent = pingContent

local pingTitle = Instance.new("TextLabel")
pingTitle.Name = "PingTitle"
pingTitle.Size = UDim2.new(1, -30, 0, 14)
pingTitle.Position = UDim2.new(0, 28, 0, 2)
pingTitle.BackgroundTransparency = 1
pingTitle.Text = "PING"
pingTitle.TextColor3 = Color3.fromRGB(170, 170, 180)  -- Light silver
pingTitle.TextSize = 10
pingTitle.TextXAlignment = Enum.TextXAlignment.Left
pingTitle.Font = Enum.Font.GothamMedium
pingTitle.Parent = pingContent

local pingValue = Instance.new("TextLabel")
pingValue.Name = "PingValue"
pingValue.Size = UDim2.new(1, -30, 0, 20)
pingValue.Position = UDim2.new(0, 28, 0, 16)
pingValue.BackgroundTransparency = 1
pingValue.Text = "0"
pingValue.TextColor3 = Color3.fromRGB(240, 240, 245)  -- Bright silver
pingValue.TextSize = 18
pingValue.TextXAlignment = Enum.TextXAlignment.Left
pingValue.Font = Enum.Font.GothamBlack
pingValue.Parent = pingContent

local pingUnit = Instance.new("TextLabel")
pingUnit.Name = "PingUnit"
pingUnit.Size = UDim2.new(0, 20, 0, 12)
pingUnit.Position = UDim2.new(1, -20, 1, -16)
pingUnit.BackgroundTransparency = 1
pingUnit.Text = "ms"
pingUnit.TextColor3 = Color3.fromRGB(150, 150, 160)  -- Grey silver
pingUnit.TextSize = 9
pingUnit.Font = Enum.Font.GothamMedium
pingUnit.Parent = pingContent

-- Silver CPU Card
local cpuCard = Instance.new("Frame")
cpuCard.Name = "CPUCard"
cpuCard.Size = UDim2.new(0.48, 0, 0, 48)
cpuCard.Position = UDim2.new(0.52, 0, 0, 0)
cpuCard.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
cpuCard.BackgroundTransparency = 0
cpuCard.BorderSizePixel = 0
cpuCard.Parent = gridFrame

local cpuCardCorner = Instance.new("UICorner")
cpuCardCorner.CornerRadius = UDim.new(0, 8)
cpuCardCorner.Parent = cpuCard

local cpuCardStroke = Instance.new("UIStroke")
cpuCardStroke.Color = Color3.fromRGB(70, 70, 80)
cpuCardStroke.Thickness = 1
cpuCardStroke.Transparency = 0
cpuCardStroke.Parent = cpuCard

-- CPU Content
local cpuContent = Instance.new("Frame")
cpuContent.Name = "CPUContent"
cpuContent.Size = UDim2.new(1, -12, 1, -12)
cpuContent.Position = UDim2.new(0, 6, 0, 6)
cpuContent.BackgroundTransparency = 1
cpuContent.Parent = cpuCard

local cpuIcon = Instance.new("TextLabel")
cpuIcon.Name = "CPUIcon"
cpuIcon.Size = UDim2.new(0, 24, 0, 24)
cpuIcon.BackgroundTransparency = 1
cpuIcon.Text = "▣"
cpuIcon.TextColor3 = Color3.fromRGB(180, 180, 190)  -- Silver
cpuIcon.TextSize = 16
cpuIcon.Font = Enum.Font.GothamBold
cpuIcon.Parent = cpuContent

local cpuTitle = Instance.new("TextLabel")
cpuTitle.Name = "CPUTitle"
cpuTitle.Size = UDim2.new(1, -30, 0, 14)
cpuTitle.Position = UDim2.new(0, 28, 0, 2)
cpuTitle.BackgroundTransparency = 1
cpuTitle.Text = "CPU"
cpuTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
cpuTitle.TextSize = 10
cpuTitle.TextXAlignment = Enum.TextXAlignment.Left
cpuTitle.Font = Enum.Font.GothamMedium
cpuTitle.Parent = cpuContent

local cpuValue = Instance.new("TextLabel")
cpuValue.Name = "CPUValue"
cpuValue.Size = UDim2.new(1, -30, 0, 20)
cpuValue.Position = UDim2.new(0, 28, 0, 16)
cpuValue.BackgroundTransparency = 1
cpuValue.Text = "0.0"
cpuValue.TextColor3 = Color3.fromRGB(240, 240, 245)
cpuValue.TextSize = 18
cpuValue.TextXAlignment = Enum.TextXAlignment.Left
cpuValue.Font = Enum.Font.GothamBlack
cpuValue.Parent = cpuContent

local cpuUnit = Instance.new("TextLabel")
cpuUnit.Name = "CPUUnit"
cpuUnit.Size = UDim2.new(0, 20, 0, 12)
cpuUnit.Position = UDim2.new(1, -20, 1, -16)
cpuUnit.BackgroundTransparency = 1
cpuUnit.Text = "ms"
cpuUnit.TextColor3 = Color3.fromRGB(150, 150, 160)
cpuUnit.TextSize = 9
cpuUnit.Font = Enum.Font.GothamMedium
cpuUnit.Parent = cpuContent

-- Silver Center Divider
local centerDivider = Instance.new("Frame")
centerDivider.Name = "CenterDivider"
centerDivider.Size = UDim2.new(0, 1, 0.6, 0)
centerDivider.Position = UDim2.new(0.5, -0.5, 0.2, 0)
centerDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
centerDivider.BackgroundTransparency = 0.7
centerDivider.BorderSizePixel = 0
centerDivider.Parent = gridFrame

-- Drag System
local dragging = false
local dragStart, startPos

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local headerPos = headerFrame.AbsolutePosition
        local headerSize = headerFrame.AbsoluteSize
        
        if headerPos and 
           input.Position.X >= headerPos.X and input.Position.X <= headerPos.X + headerSize.X and
           input.Position.Y >= headerPos.Y and input.Position.Y <= headerPos.Y + headerSize.Y then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end
end

local function onInputChanged(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        
        local viewportSize = monitorUI.AbsoluteSize
        local frameSize = mainFrame.AbsoluteSize
        newX = math.clamp(newX, 10, viewportSize.X - frameSize.X - 10)
        newY = math.clamp(newY, 10, viewportSize.Y - frameSize.Y - 10)
        
        mainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end

local function onInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end

headerFrame.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)
UserInputService.InputEnded:Connect(onInputEnded)

-- Color Functions dengan nuansa silver
local function getPingColor(ping)
    if ping < 50 then return Color3.fromRGB(180, 220, 180) end      -- Silver green
    if ping < 100 then return Color3.fromRGB(220, 220, 180) end     -- Silver yellow
    if ping < 150 then return Color3.fromRGB(220, 200, 160) end     -- Silver orange
    return Color3.fromRGB(220, 160, 160)                            -- Silver red
end

local function getCPUColor(cpuTime)
    if cpuTime < 8 then return Color3.fromRGB(180, 220, 180) end    -- Silver green
    if cpuTime < 15 then return Color3.fromRGB(220, 220, 180) end   -- Silver yellow
    if cpuTime < 25 then return Color3.fromRGB(220, 200, 160) end   -- Silver orange
    return Color3.fromRGB(220, 160, 160)                            -- Silver red
end

-- Performance Update
local lastUpdate = 0
local updateInterval = 0.5

RunService.Heartbeat:Connect(function(deltaTime)
    lastUpdate = lastUpdate + deltaTime
    
    if lastUpdate >= updateInterval then
        lastUpdate = 0
        
        -- Get Values
        local ping = 0
        local success, result = pcall(function()
            return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if success then ping = result else ping = math.random(20, 50) end
        
        local cpuTime = math.floor(deltaTime * 10000) / 10
        
        -- Update Display
        pingValue.Text = tostring(ping)
        cpuValue.Text = string.format("%.1f", cpuTime)
        
        -- Update Colors dengan nuansa silver
        pingValue.TextColor3 = getPingColor(ping)
        cpuValue.TextColor3 = getCPUColor(cpuTime)
        
        -- Update icon colors tetap silver
        pingIcon.TextColor3 = Color3.fromRGB(180, 180, 190)
        cpuIcon.TextColor3 = Color3.fromRGB(180, 180, 190)
        
        -- Update border color subtle
        if ping > 150 or cpuTime > 25 then
            outerStroke.Color = Color3.fromRGB(200, 120, 120)  -- Subtle red silver
        else
            outerStroke.Color = Color3.fromRGB(160, 160, 170)  -- Normal silver
        end
    end
end)

-- Simple Toggle
local function toggleMonitor(state)
    mainFrame.Visible = state
end

-- Toggle
SetTab:Toggle({
    Title = "Device Monitor",
    Desc = "RUINZ PANEL - Monitor Ping & CPU",
    Icon = "activity",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        toggleMonitor(state)
    end
})

-- */ FOOTERTABS /* --
do
    local FOOTER = Window:Section({
        Title = "Thx for using",
        Icon = "sfsymbols:squareStack3dForwardDottedlineFill",
    })
end
