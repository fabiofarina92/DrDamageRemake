local _, playerClass = UnitClass("player")
local playerHealer = (playerClass == "PRIEST") or (playerClass == "SHAMAN") or
        (playerClass == "PALADIN") or (playerClass == "DRUID")
local playerCaster = (playerClass == "MAGE") or (playerClass == "PRIEST") or
        (playerClass == "WARLOCK")
local playerMelee = (playerClass == "ROGUE") or (playerClass == "WARRIOR") or
        (playerClass == "HUNTER")
local playerHybrid = (playerClass == "DRUID") or (playerClass == "PALADIN") or
        (playerClass == "SHAMAN")


-- Libraries
local L = LibStub("AceLocale-3.0"):GetLocale("DrDamage", true)
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local DrDamage = DrDamage
DrDamageRemake = LibStub("AceAddon-3.0"):NewAddon("DrDamageRemake",
    "AceHook-3.0",
    "AceConsole-3.0",
    "AceEvent-3.0",
    "AceTimer-3.0", "AceComm-3.0",
    "AceSerializer-3.0")

-- General
local settings
local _G = getfenv(0)
local type = type
local pairs = pairs
local tonumber = tonumber
local math_floor = math.floor
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local string_match = string.match
local string_format = string.format
local string_find = string.find
local string_sub = string.sub
local string_gsub = string.gsub
local string_len = string.len
local select = select
local next = next

local playerLogin = CreateFrame("frame")
playerLogin:RegisterEvent("PLAYER_LOGIN")
playerLogin:SetScript("OnEvent", function()
    DrDamageRemake:OnInitialize()
end)

-- Module
local GameTooltip = GameTooltip
local Utils = DrDamageRemake
local ActionButton_GetPagedID = ActionButton_GetPagedID
local GetSpellInfo = GetSpellInfo
local GetMacroSpell = GetMacroSpell
local GetMacroBody = GetMacroBody
local GetActionInfo = GetActionInfo

-- Module variables
local playerCompatible, playerEvents, DrD_Font, updateSetItems, dmgMod
local spellInfo, talentInfo, talents, PlayerHealth, TargetHealth, classColour
local ModStateEvent, Casts, ManaCost, PowerCost
local ABobjects = {}

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10 ^ numDecimalPlaces
        return math_floor(num * mult + 0.5) / mult
    end
    return math_floor(num + 0.5)
end

function DrDamageRemake:OnInitialize()
    self:loadABList()
end

local function addLine(tooltip, property, value, type)
    type = type or ''
    local frame, text
    for i = 1, 15 do
        frame = _G[tooltip:GetName() .. "TextLeft" .. i]
        if frame then text = frame:GetText() end
        if text and text == property then return end
    end

    local valueC = '|cff' .. classColour .. value .. '|r'
    colourType = {
        ['Damage'] = function(x) return '|cffe33636' .. x .. '|r' end,
        ['Heal'] = function(x) return '|cff3eed46' .. x .. '|r' end,
        ['Mana'] = function(x) return '|cff00eaff' .. x .. '|r' end,
        ['Stat'] = function(x) return '|cff' .. classColour .. x .. '|r' end,
        [''] = function(x) return '|cff' .. classColour .. x .. '|r' end,
        ['property'] = function(x) return '|cffffffff' .. x .. '|r' end
    }

    tooltip:AddDoubleLine(colourType['property'](property),
        colourType[type](value))
    tooltip:Show()
end

function DrDamageRemake:OnEnable()
    self:HookScript(GameTooltip, "OnTooltipSetSpell", "ProcessOnShow")
    self:PlayerData()
    spellInfo = self.spellInfo
    classColour = self.classColour
end

function DrDamageRemake:ProcessOnShow(tooltip, ...)
    local id = select(2, tooltip:GetSpell())
    local name = select(1, tooltip:GetSpell())

    if name and id then
        tooltip:AddLine(' ')
        addLine(tooltip, "Id", id)
        addLine(tooltip, "Name", name)
        if spellInfo[name] then
            local details = spellInfo[name]
            local tooltipData = details["toolTipData"]

            self:ParseTooltip(tooltip, spellInfo[name])

            --            addLine(tooltip, "Rank", details[id]["rank"])

            for i, v in ipairs(tooltipData) do
                addLine(tooltip, v.label, v.calculation(details["data"]), v.type)
            end

            Utils:MainHandDamage()
        end
    end

    self.hooks[GameTooltip]["OnTooltipSetSpell"](tooltip, ...)
end

function DrDamageRemake:ParseTooltip(tooltip, spell)
    local matcher
    if spell["match"] then
        local frame, text
        for i = 1, 15 do
            frame = _G[tooltip:GetName() .. "TextRight" .. i]
            if frame then
                text = frame:GetText()
                if text then
                    if matcher and text:match(matcher) then
                        local cooldown = text:match(matcher)
                        spell["data"].cooldown.standard = tonumber(cooldown)
                    end
                end
            end
        end
        for i = 1, 15 do
            frame = _G[tooltip:GetName() .. "TextLeft" .. i]
            if frame then
                text = frame:GetText()
                if text then
                    matcher = spell["match"]['damageRange']
                    if matcher and text:match(matcher) then
                        local lowerBound, upperBound = text:match(matcher)
                        spell["data"].lowerBound = tonumber(lowerBound)
                        spell["data"].upperBound = tonumber(upperBound)
                    end
                    matcher = spell["match"]['cost']
                    if matcher and text:match(matcher) then
                        local cost = text:match(matcher)
                        spell["data"].rageCost = tonumber(cost)
                    end
                    matcher = spell["match"]['damage']
                    if matcher and text:match(matcher) then
                        local damage = text:match(matcher)
                        spell["data"].lowerBound = tonumber(damage)
                        spell["data"].upperBound = tonumber(damage)
                        spell["data"].damage = tonumber(damage)
                    end
                    matcher = spell["match"]['damageOverTime']
                    if matcher and text:match(matcher) then
                        local total, duration = text:match(matcher)
                        spell["data"].dot.total = tonumber(total)
                        spell["data"].dot.duration = tonumber(duration)
                    end
                    matcher = spell["match"]['extra']
                    if matcher and text:match(matcher) then
                        local extra = text:match(matcher)
                        spell["data"].extra = tonumber(extra)
                    end
                    matcher = spell["match"]['cast']
                    if matcher and text:match(matcher) then
                        local extra = text:match(matcher)
                        spell["data"].castTime = tonumber(extra)
                    end
                end
            end
        end
    end
end

function DrDamageRemake:loadABList()
    for i = 1, 6 do
        for j = 1, 12 do
            table.insert(ABobjects, _G[((select(i, "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton")) .. j)])
        end
    end
    local thingType, _, _ = GetActionInfo(2)
    for i = 1, #ABobjects do
        local button = ABobjects[i]
        if button then
            local drd
            local id = ActionButton_GetPagedID(button)
            if id then
                local gtype, pid = GetActionInfo(id)
                local name, rank
                if gtype == "spell" and pid ~= 0 then
                    name, rank = GetSpellInfo(pid)
                elseif gtype == "macro" then
                    name, rank = GetMacroSpell(pid)
                end
                if name then
                    drd = button:CreateFontString(button:GetName() .. "drd", "OVERLAY")
                    drd:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 6)
                    drd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
                    drd:SetJustifyH("CENTER")
                    drd:SetTextColor(255,255,255)
                    drd:SetFont(GameFontNormal:GetFont(), 11, "OUTLINE", "MONOCHROME")
                    drd:SetText('100')
                    drd:Show()
                end
            end

        end
--        self:CheckAction(button, button:GetName(), ActionButton_GetPagedID, spell, mana, disable)
    end
end

