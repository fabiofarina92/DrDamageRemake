if select(2, UnitClass("player")) ~= "WARRIOR" then return end
local GetManaRegen = GetManaRegen
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitAttackPower = UnitAttackPower
local UnitStat = UnitStat
local GetInventoryItemLink = GetInventoryItemLink
local GetShapeshiftForm = GetShapeshiftForm
local critModifier = 2.0

function DrDamageRemake:getCurrentAttackPower(baseAp)
    local base, posBuff, negBuff = UnitAttackPower("player")
    if baseAp then
        return base
    end

    local totalAttackPower = base + posBuff + negBuff

    return totalAttackPower
end

function DrDamageRemake:defaultDamageCalculationAmount(data)
    local base, posBuff, negBuff = UnitAttackPower("player")

    local totalAttackPower = base + posBuff + negBuff
    local average = math.floor((data.lowerBound + data.upperBound) / 2)
    local modifiers = totalAttackPower * data.attackPowerMod
    local calculation = average + modifiers
    return calculation
end

function DrDamageRemake:defaultCritDamageCalculationAmount(data)
    return self:defaultDamageCalculationAmount(data) * critModifier
end

function DrDamageRemake:damagePerRage(data)
    return self:defaultDamageCalculationAmount(data) / data.rageCost
end

function DrDamageRemake:damagePerSecond(data)
    local castsPerMinute = self:castsPerMinute(data)

    local totalDamagePerMinute = castsPerMinute *
                                     self:defaultDamageCalculationAmount(data)
    return round(totalDamagePerMinute / 60, 2)
end
function DrDamageRemake:castsPerMinute(data)
    local castsPerMinute = 0
    if data.cooldown.gcd > data.cooldown.standard then
        castsPerMinute = 60 / data.cooldown.gcd
    else
        castsPerMinute = 60 / data.cooldown.standard
    end
    return castsPerMinute
end

function DrDamageRemake:damagePerSecondCalc(castsPerMinute, damage)
    local totalDamagePerMinute = castsPerMinute * damage
    return round(totalDamagePerMinute / 60, 2)
end

function DrDamageRemake:getBlockValue(data)
    local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 1)

    local strength = stat + posBuff + negBuff

    local stats = GetItemStats(GetInventoryItemLink("player", 17))

end

function DrDamageRemake:PlayerData()
    self.classColour = 'bf5d39'
    self.spellInfo = {
        [1715] = {
            ["name"] = "Hamstring",
            ["id"] = 1715,
            ["rank"] = 1,
            ["data"] = {
                lowerBound = 5,
                upperBound = 5,
                rageCost = 10,
                castTime = 0,
                attackPowerMod = 0,
                cooldown = {standard = 0, gcd = 1.5}
            },
            ["info"] = {school = {"Physical"}},
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:defaultDamageCalculationAmount(data)
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:defaultCritDamageCalculationAmount(data)
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:damagePerRage(data)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:damagePerSecond(data)
                    end)
                }
            }
        },
        [23923] = {
            ["name"] = "Shield Slam",
            ["id"] = 23923,
            ["rank"] = 2,
            ["data"] = {
                lowerBound = 264,
                upperBound = 276,
                rageCost = 20,
                castTime = 0,
                attackPowerMod = 0,
                cooldown = {standard = 6, gcd = 1.5}
            },
            ["info"] = {school = {"Physical"}},
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        self:getBlockValue(data)
                        return string.format("%s (%s - %s)",
                                             self:defaultDamageCalculationAmount(
                                                 data), (data.lowerBound),
                                             (data.upperBound))
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return string.format("%s (%s - %s)",
                                             self:defaultCritDamageCalculationAmount(
                                                 data),
                                             (data.lowerBound * critModifier),
                                             (data.upperBound * critModifier))
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:damagePerRage(data)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:damagePerSecond(data)
                    end)
                }
            }
        },
        [23892] = {
            ["name"] = "Bloodthirst",
            ["id"] = 23892,
            ["rank"] = 2,
            ["data"] = {
                lowerBound = 0,
                upperBound = 0,
                rageCost = 30,
                castTime = 0,
                attackPowerMod = 0.45,
                cooldown = {standard = 6, gcd = 1.5}
            },
            ["info"] = {school = {"Physical"}},
            ["toolTipData"] = {
                [1] = {
                    label = "Average (at 0 armour)",
                    type = 'Damage',
                    calculation = (function(data)
                        return (self:getCurrentAttackPower(false) *
                                   data.attackPowerMod)
                    end)
                },
                [2] = {
                    label = "Crit (at 0 armour)",
                    type = 'Damage',
                    calculation = (function(data)
                        return (self:getCurrentAttackPower(false) *
                                   data.attackPowerMod) * 2
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        return (self:getCurrentAttackPower() *
                                   data.attackPowerMod) / data.rageCost
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:damagePerSecond(data)
                    end)
                }
            }
        }
    }
end
