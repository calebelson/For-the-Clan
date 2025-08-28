-- ForTheClan Addon
-- Automatically yells and plays sounds when receiving specific buffs

local addonName, addon = ...
local frame = CreateFrame("Frame")
local configFrame
local isConfigOpen = false

-- LibDBIcon support
local LibDBIcon
local forTheClanLDB

-- Default configuration
local defaultConfig = {
    yell = "为了部落",
    sound = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeCN.mp3",
    minimap = {
        hide = false,
    }
}

-- Initialize saved variables
ForTheClanDB = ForTheClanDB or defaultConfig

-- Buff list (you can modify this list)
local buffList = {
    "Ancient Hysteria",           -- 90355
    "Bloodlust",                  -- 2825
    "Drums of Fury",              -- 178207
    "Drums of the Mountain",      -- 230935
    "Heroism",                    -- 32182
    "Netherwinds",                -- 160452
    "Time Warp",                  -- 80353
    "Mallet of Thunderous Skins", -- 292686
    "Drums of the Maelstrom",     -- 256740
    "Drums of Deathly Ferocity",  -- 309658
    "Fury of the Aspects",        -- 390386
    "Primal Rage",                -- 264667
    "Feral Hide Drums",           -- 390386
    "Timeless Drums",             -- 264667
    "Lightning Shield",           -- 192106
    "Thunderous Drums"            -- 444122
}

-- Sound list with display names and actual file paths
local soundList = {
    {display = "Chinese", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeCN.mp3"},
    {display = "English", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeEN.mp3"},
    {display = "French", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeFR.mp3"},
    {display = "German", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeDE.mp3"},
    {display = "Italian", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeIT.mp3"},
    {display = "Korean", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeKR.mp3"},
    {display = "Portuguese", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeBR.mp3"},
    {display = "Russian", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeRU.mp3"},
    {display = "Spanish - EU", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeES.mp3"},
    {display = "Spanish - LA", file = "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeLA.mp3"},
    {display = "Nothing", file = "Nothing"}
}

-- Yell list with display names and actual yell values
local yellList = {
    {display = "Chinese", yell = "为了部落"},
    {display = "English", yell = "For The Horde!"},
    {display = "French", yell = "Pour la Horde!"},
    {display = "German", yell = "Für die Horde!"},
    {display = "Italian", yell = "Per l'Orda"},
    {display = "Korean", yell = "호드를 위하여!"},
    {display = "Portuguese", yell = "Pela Horda!"},
    {display = "Russian", yell = "За Орду!!"},
    {display = "Spanish", yell = "¡Por la Horda!"},
    {display = "Nothing", yell = "Nothing"}
}

-- Initialize configuration if not exists
local function InitializeConfig()
    -- Ensure all default values exist
    for key, value in pairs(defaultConfig) do
        if ForTheClanDB[key] == nil then
            ForTheClanDB[key] = value
        end
    end
end

-- Create LibDBIcon minimap button
local function CreateMinimapIcon()
    -- Get LibDBIcon library
    LibDBIcon = LibStub("LibDBIcon-1.0", true)
    if not LibDBIcon then
        print("ForTheClan: LibDBIcon-1.0 not found")
        return
    end
    
    -- Create LDB object using LibDataBroker-1.1
    local LDB = LibStub("LibDataBroker-1.1", true)
    if not LDB then
        print("ForTheClan: LibDataBroker-1.1 not found")
        return
    end
    
    -- Create the data object
    forTheClanLDB = LDB:NewDataObject("ForTheClan", {
        type = "launcher",
        text = "ForTheClan",
        icon = "Interface\\AddOns\\ForTheClan\\assets\\HordeSymbolIcon64",
        OnClick = function(self, button)
            if button == "LeftButton" then
                ToggleConfigWindow()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("ForTheClan")
            tooltip:AddLine("Left click to open configuration", 1, 1, 1)
        end,
    })
    
    -- Register with LibDBIcon
    LibDBIcon:Register("ForTheClan", forTheClanLDB, ForTheClanDB.minimap)
    
    print("ForTheClan: Minimap icon created with LibDBIcon")
end

-- LibDBIcon support
local LibDBIcon
local forTheClanLDB

-- Create configuration window
local function CreateConfigWindow()
    configFrame = CreateFrame("Frame", "ForTheClanConfigFrame", UIParent, "BasicFrameTemplateWithInset")
    configFrame:SetSize(400, 300)
    configFrame:SetPoint("CENTER")
    configFrame:SetMovable(true)
    configFrame:EnableMouse(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetScript("OnDragStart", configFrame.StartMoving)
    configFrame:SetScript("OnDragStop", configFrame.StopMovingOrSizing)
    
    -- Title
    local title = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", configFrame, "TOP", 0, -5)
    title:SetText("ForTheClan Configuration")
    
    -- Yell dropdown
    local yellDropdown = CreateFrame("Frame", nil, configFrame, "UIDropDownMenuTemplate")
    yellDropdown:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -50)
    
    local yellText = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    yellText:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -30)
    yellText:SetText("Yell:")
    
    UIDropDownMenu_SetWidth(yellDropdown, 200)
    
    -- Set initial text based on current yell value
    local currentYell = ForTheClanDB.yell or "为了部落"
    local currentDisplay = "Chinese"
    for _, yellData in ipairs(yellList) do
        if yellData.yell == currentYell then
            currentDisplay = yellData.display
            break
        end
    end
    UIDropDownMenu_SetText(yellDropdown, currentDisplay)
    
    -- Yell preview text
    local yellPreview = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    yellPreview:SetPoint("LEFT", yellDropdown, "RIGHT", 10, 2)
    yellPreview:SetText('"' .. (ForTheClanDB.yell or "为了部落") .. '"')
    yellPreview:SetTextColor(0.8, 1, 0.8) -- Light green color
    
    UIDropDownMenu_Initialize(yellDropdown, function(self, level)
        for _, yellData in ipairs(yellList) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = yellData.display
            info.value = yellData.yell
            info.checked = (yellData.yell == ForTheClanDB.yell)
            info.func = function(self)
                ForTheClanDB.yell = yellData.yell
                UIDropDownMenu_SetText(yellDropdown, yellData.display)
                yellPreview:SetText('"' .. yellData.yell .. '"') -- Update preview
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Note about yell restrictions
    local note = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    note:SetPoint("TOPLEFT", yellDropdown, "BOTTOMLEFT", 5, -5)
    note:SetText("Note: Automated yell messages are blocked outside of instances")
    note:SetTextColor(1, 0.8, 0)
    
    -- Sound dropdown
    local soundDropdown = CreateFrame("Frame", nil, configFrame, "UIDropDownMenuTemplate")
    soundDropdown:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -120)
    
    local soundText = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    soundText:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -100)
    soundText:SetText("Sound:")
    
    UIDropDownMenu_SetWidth(soundDropdown, 200)
    
    -- Get current sound display name
    local currentSound = ForTheClanDB.sound or "Interface\\AddOns\\ForTheClan\\sounds\\ForTheHordeCN.mp3"
    local currentDisplayName = "Chinese"
    for _, soundData in ipairs(soundList) do
        if soundData.file == currentSound then
            currentDisplayName = soundData.display
            break
        end
    end
    
    UIDropDownMenu_SetText(soundDropdown, currentDisplayName)
    
    UIDropDownMenu_Initialize(soundDropdown, function(self, level)
        for _, soundData in ipairs(soundList) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = soundData.display
            info.value = soundData.file
            info.checked = (soundData.file == ForTheClanDB.sound)
            info.func = function(self)
                ForTheClanDB.sound = soundData.file
                UIDropDownMenu_SetText(soundDropdown, soundData.display)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Play button for sound testing
    local playButton = CreateFrame("Button", nil, configFrame, "GameMenuButtonTemplate")
    playButton:SetSize(60, 25)
    playButton:SetPoint("LEFT", soundDropdown, "RIGHT", 10, 2)
    playButton:SetText("Play")
    playButton:SetScript("OnClick", function()
        local soundFile = ForTheClanDB.sound or "Interface\\AddOns\\ForTheClan\\assets\\sounds\\ForTheHordeCN.mp3"
        PlaySoundFile(soundFile, "Master")
    end)
    
    -- Show Minimap Button checkbox
    local minimapCheckbox = CreateFrame("CheckButton", nil, configFrame, "UICheckButtonTemplate")
    minimapCheckbox:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 20, -180)
    minimapCheckbox:SetChecked(not ForTheClanDB.minimap.hide)
    minimapCheckbox:SetScript("OnClick", function(self)
        ForTheClanDB.minimap.hide = not self:GetChecked()
        if LibDBIcon then
            if ForTheClanDB.minimap.hide then
                LibDBIcon:Hide("ForTheClan")
            else
                LibDBIcon:Show("ForTheClan")
            end
        end
    end)
    
    local minimapText = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    minimapText:SetPoint("LEFT", minimapCheckbox, "RIGHT", 5, 0)
    minimapText:SetText("Show Minimap Button")
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, configFrame, "GameMenuButtonTemplate")
    closeButton:SetSize(100, 30)
    closeButton:SetPoint("BOTTOM", configFrame, "BOTTOM", 0, 20)
    closeButton:SetText("Close")
    closeButton:SetScript("OnClick", function()
        configFrame:Hide()
        isConfigOpen = false
    end)
    
    configFrame:Hide()
end

-- Toggle configuration window
function ToggleConfigWindow()
    if not configFrame then
        CreateConfigWindow()
    end
    
    if isConfigOpen then
        configFrame:Hide()
        isConfigOpen = false
    else
        configFrame:Show()
        isConfigOpen = true
    end
end

-- Track which buffs are currently active to avoid duplicate triggers
local activeBuffs = {}

-- Create addon options panel
local function CreateAddonOptionsPanel()
    local panel = CreateFrame("Frame")
    panel.name = "ForTheClan"
    
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("ForTheClan Settings")
    
    local description = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    description:SetText("Configure automatic buff notifications and sounds")
    
    local note = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    note:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -16)
    note:SetText("Use /ftc, /fortheclan, or the minimap button for detailed configuration")
    note:SetTextColor(0.8, 0.8, 0.8)
    
    -- Open Configuration button
    local configButton = CreateFrame("Button", nil, panel, "GameMenuButtonTemplate")
    configButton:SetSize(200, 30)
    configButton:SetPoint("TOPLEFT", note, "BOTTOMLEFT", 0, -16)
    configButton:SetText("Open Configuration")
    configButton:SetScript("OnClick", function()
        ToggleConfigWindow()
    end)
    
    -- Version info
    local versionText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    versionText:SetPoint("BOTTOMLEFT", 16, 16)
    versionText:SetText("Version: 1.0.0")
    
    -- Try to add to Interface Options (MoP Classic and older retail)
    if InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end
    
    -- For newer retail versions with the new Settings system
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(category)
    end
end

-- Initialize addon
local function Initialize()
    InitializeConfig()
    CreateMinimapIcon()
    
    print("|cFF00FF00ForTheClan|r addon loaded! Use /ftc or the minimap button to configure.")
end

-- Handle all events in one place
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "ForTheClan" then
        Initialize()
        CreateAddonOptionsPanel()
    elseif event == "UNIT_AURA" then
        local unit = ...
        if unit == "player" then
            local currentBuffs = {}
            
            -- Check for buffs using modern API
            for i = 1, 40 do
                local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitBuff("player", i)
                if name then
                    currentBuffs[name] = true
                    
                    -- Check if this is a new buff we haven't triggered yet
                    for _, buff in ipairs(buffList) do
                        if name == buff and not activeBuffs[name] then
                            -- Play sound (if not set to "Nothing")
                            if ForTheClanDB.sound and ForTheClanDB.sound ~= "Nothing" then
                                PlaySoundFile(ForTheClanDB.sound)
                            end
                            
                            -- Send yell (if not set to "Nothing")
                            if ForTheClanDB.yell and ForTheClanDB.yell ~= "Nothing" then
                                SendChatMessage(ForTheClanDB.yell, "YELL")
                            end
                            
                            -- Mark this buff as triggered
                            activeBuffs[name] = true
                            
                            -- Break to avoid multiple triggers for the same buff
                            break
                        end
                    end
                end
            end
            
            -- Remove buffs that are no longer active
            for buffName, _ in pairs(activeBuffs) do
                if not currentBuffs[buffName] then
                    activeBuffs[buffName] = nil
                end
            end
        end
    end
end

-- Slash command
SLASH_FORTHECLAN1 = "/ftc"
SLASH_FORTHECLAN2 = "/fortheclan"
SlashCmdList["FORTHECLAN"] = function(msg)
    ToggleConfigWindow()
end

-- Set up the unified event handler
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN") 
frame:RegisterEvent("UNIT_AURA")
frame:SetScript("OnEvent", OnEvent)
