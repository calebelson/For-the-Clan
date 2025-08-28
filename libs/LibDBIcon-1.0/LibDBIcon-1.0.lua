-- LibDBIcon-1.0 by Nevcairiel
-- A library for creating minimap icons for addons
-- This is a simplified version for basic functionality

local libDBIcon = LibStub:NewLibrary("LibDBIcon-1.0", 1)
if not libDBIcon then return end

local minimap = _G.Minimap
local ldb = LibStub and LibStub("LibDataBroker-1.1", true)
local iconObjects = {}
local buttonRegistry = {}
local db

local function updateIcon(iconName)
    local button = buttonRegistry[iconName]
    if not button then return end
    
    local icon = iconObjects[iconName]
    if not icon then return end
    
    if icon.hide or (db and db.hide) then
        button:Hide()
    else
        button:Show()
    end
end

local function createButton(iconName, dataObject)
    local button = CreateFrame("Button", "LibDBIcon10_"..iconName, minimap)
    button.data = dataObject
    button.isMouseDown = false
    
    button:SetFrameStrata("MEDIUM")
    button:SetSize(31, 31)
    button:SetFrameLevel(8)
    button:RegisterForDrag("LeftButton")
    button:SetHighlightTexture(136477) --"Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"
    
    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture(136430) --"Interface\\Minimap\\MiniMap-TrackingBorder"
    overlay:SetPoint("TOPLEFT", -11, 11)
    button.overlay = overlay
    
    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetSize(20, 20)
    background:SetTexture(136467) --"Interface\\Minimap\\UI-Minimap-ButtonUp"
    background:SetPoint("TOPLEFT", 6, -6)
    button.background = background
    
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(17, 17)
    icon:SetTexture(dataObject.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    icon:SetPoint("TOPLEFT", 7, -7)
    button.icon = icon
    
    button:SetScript("OnClick", function(self, b)
        if self.data.OnClick then
            self.data.OnClick(self, b)
        end
    end)
    
    button:SetScript("OnEnter", function(self)
        if self.data.OnTooltipShow then
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPRIGHT")
            self.data.OnTooltipShow(GameTooltip)
            GameTooltip:Show()
        elseif self.data.tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPRIGHT")
            GameTooltip:SetText(self.data.tooltip)
            GameTooltip:Show()
        end
    end)
    
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    button:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            if px and py then
                px, py = px / scale, py / scale
                if db then
                    db.minimapPos = math.deg(math.atan2(py - my, px - mx)) % 360
                end
                self:SetPoint("CENTER", Minimap, "CENTER", (px - mx) * math.cos(math.rad(db.minimapPos)), (py - my) * math.sin(math.rad(db.minimapPos)))
            end
        end)
    end)
    
    button:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
        updateIcon(iconName)
    end)
    
    buttonRegistry[iconName] = button
    updateIcon(iconName)
    
    return button
end

function libDBIcon:Register(iconName, dataObject, dbObject)
    if not iconName or not dataObject then return end
    
    db = dbObject
    iconObjects[iconName] = dataObject
    
    if not buttonRegistry[iconName] then
        createButton(iconName, dataObject)
    end
    
    updateIcon(iconName)
end

function libDBIcon:CreateIcon(iconName, callback)
    return {
        icon = "Interface\\Icons\\INV_Misc_QuestionMark",
        OnClick = callback,
        tooltip = iconName
    }
end

function libDBIcon:SetIcon(iconName, iconPath)
    if iconObjects[iconName] then
        iconObjects[iconName].icon = iconPath
        if buttonRegistry[iconName] then
            buttonRegistry[iconName].icon:SetTexture(iconPath)
        end
    end
end

function libDBIcon:SetTooltip(iconName, tooltipText)
    if iconObjects[iconName] then
        iconObjects[iconName].tooltip = tooltipText
    end
end

function libDBIcon:Show(iconName)
    if buttonRegistry[iconName] then
        buttonRegistry[iconName]:Show()
    end
end

function libDBIcon:Hide(iconName)
    if buttonRegistry[iconName] then
        buttonRegistry[iconName]:Hide()
    end
end

function libDBIcon:Refresh(iconName)
    updateIcon(iconName)
end
