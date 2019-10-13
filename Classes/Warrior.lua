if select(2, UnitClass("player")) ~= "WARRIOR" then return end
local UnitStat = UnitStat
local GetInventoryItemLink = GetInventoryItemLink
local GetShapeshiftForm = GetShapeshiftForm
local critModifier = 2.0
local Utils = DrDamageRemake

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
                mod = 0,
                cooldown = {standard = 0, gcd = 1.5}
            },
            ["info"] = {school = {"Physical"}},
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:DefaultDamageCalculationAmount(data)
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:DefaultCritDamageCalculationAmount(data, critModifier)
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:DamagePerPowerCost(data, data.rageCost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:DamagePerSecond(data)
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
                mod = 0,
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
                                             self:DefaultDamageCalculationAmount(
                                                 data), (data.lowerBound),
                                             (data.upperBound))
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return string.format("%s (%s - %s)",
                                             self:DefaultCritDamageCalculationAmount(
                                                 data, critModifier),
                                             (data.lowerBound * critModifier),
                                             (data.upperBound * critModifier))
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:DamagePerPowerCost(data, data.rageCost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:DamagePerSecond(data)
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
                mod = 0.45,
                cooldown = {standard = 6, gcd = 1.5}
            },
            ["info"] = {school = {"Physical"}},
            ["toolTipData"] = {
                [1] = {
                    label = "Average (at 0 armour)",
                    type = 'Damage',
                    calculation = (function(data)
                        return (Utils:GetCurrentAttackPower(false) *
                                   data.mod)
                    end)
                },
                [2] = {
                    label = "Crit (at 0 armour)",
                    type = 'Damage',
                    calculation = (function(data)
                        return (Utils:GetCurrentAttackPower(false) *
                                   data.mod) * 2
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        return (Utils:GetCurrentAttackPower() *
                                   data.mod) / data.rageCost
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        return self:DamagePerSecond(data)
                    end)
                }
            }
        }
    }
end
