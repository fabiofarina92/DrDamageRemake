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

-- Module
local GameTooltip = GameTooltip
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitLevel = UnitLevel
local UnitDamage = UnitDamage
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitAttackPower = UnitAttackPower
local UnitIsUnit = UnitIsUnit
local UnitStat = UnitStat
local UnitClassification = UnitClassification
local UnitExists = UnitExists
local UnitIsPlayer = UnitIsPlayer
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local GetSpellBookItemName = GetSpellBookItemName
local GetSpellInfo = GetSpellInfo
local GetMacroSpell = GetMacroSpell
local GetMacroBody = GetMacroBody
local GetActionInfo = GetActionInfo
local GetPetActionInfo = GetPetActionInfo
local GetActionCooldown = GetActionCooldown
local GetCursorInfo = GetCursorInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetItemGem = GetItemGem
local GetTime = GetTime
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local GetTalentInfo = GetTalentInfo
local GetNumSpecializations = GetNumSpecializations
local GetNumTalents = GetNumTalents
local GetGlyphSocketInfo = GetGlyphSocketInfo
local GetCombatRatingBonus = GetCombatRatingBonus
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetAttackPowerForStat = GetAttackPowerForStat
local GetSpellCritChanceFromIntellect = GetSpellCritChanceFromIntellect
local GetCritChanceFromAgility = GetCritChanceFromAgility
local HasAction = HasAction
local IsEquippedItem = IsEquippedItem
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local SecureButton_GetModifiedAttribute = SecureButton_GetModifiedAttribute
local SecureButton_GetEffectiveButton = SecureButton_GetEffectiveButton
local ActionButton_GetPagedID = ActionButton_GetPagedID
local InCombatLockdown = InCombatLockdown
-- local IsInInstance = IsInInstance
-- local GetZonePVPInfo = GetZonePVPInfo
local GetHitModifier = GetHitModifier
local GetSpellHitModifier = GetSpellHitModifier

-- Module variables
local playerCompatible, playerEvents, DrD_Font, updateSetItems, dmgMod
local spellInfo, talentInfo, talents, PlayerHealth, TargetHealth, classColour
local ModStateEvent, Casts, ManaCost, PowerCost

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10 ^ numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function DrDamageRemake:OnInitialize() end

local function addLine(tooltip, property, value, type)
    type = type or ''
    local frame, text
    for i = 1, 15 do
        frame = _G[tooltip:GetName() .. "TextLeft" .. i]
        if frame then text = frame:GetText() end
        if text and text == property then return end
    end

    local valueC = '|c00' .. classColour .. value .. '|r'
    colourType = {
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

    if id then
        if spellInfo[id] then
            local details = spellInfo[id]
            local tooltipData = details["toolTipData"]
            -- print(spellInfo[id]["avg"](10))        

            -- local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(id)

            tooltip:AddLine(' ')
            addLine(tooltip, "Id", id)
            addLine(tooltip, "Name", details["name"])
            addLine(tooltip, "Rank", details["rank"])

            -- addLine(tooltip, tooltipData["avg"].property, tooltipData["avg"].calculation(details["data"]) , details['info'].type)
            -- addLine(tooltip, tooltipData["crit"].property, tooltipData["crit"].calculation(details["data"]) , details['info'].type)
            -- addLine(tooltip, tooltipData["castTilOom"].property, tooltipData["castTilOom"].calculation(details["data"]) , details['info'].type)
            -- addLine(tooltip, tooltipData["totalTilOom"].property, tooltipData["totalTilOom"].calculation(details["data"]) , details['info'].type)

            for i, v in ipairs(tooltipData) do
                addLine(tooltip, v.label, v.calculation(details["data"]), v.type)
            end

        end

    end

    self.hooks[GameTooltip]["OnTooltipSetSpell"](tooltip, ...)
end

