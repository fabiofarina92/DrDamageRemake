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
        ['Hamstring'] = {
            ["name"] = "Hamstring",
            [1715] = {
                ["rank"] = 1,
                ["data"] = {
                    lowerBound = 5,
                    upperBound = 5,
                    rageCost = 10,
                    castTime = 0,
                    mod = 0,
                    cooldown = { standard = 0, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        return Utils:DefaultDamageCalculationAmount(data)
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return Utils:DefaultCritDamageCalculationAmount(data, critModifier)
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local baseDamage = Utils:DefaultDamageCalculationAmount(data)
                        return Utils:DamagePerPowerCost(baseDamage, data.rageCost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        local baseDamage = Utils:DefaultDamageCalculationAmount(data)
                        return Utils:DamagePerSecond(baseDamage, data)
                    end)
                }
            }
        },
        ['Overpower'] = {
            ["name"] = "Overpower",
            [11585] = {
                ["rank"] = 4,
                ["data"] = {
                    extra = 35,
                    lowerBound = 0,
                    upperBound = 0,
                    rageCost = 5,
                    castTime = 0,
                    mod = 0,
                    cooldown = { standard = 10, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        return round(mainHandDamage.base, 2) + data.extra;
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        return round((mainHandDamage.base + data.extra) * critModifier, 2);
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local damage = Utils:MainHandDamage()
                        return Utils:DamagePerPowerCost(damage.base + data.extra, data.rageCost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        local damage = Utils:MainHandDamage()
                        return Utils:DamagePerSecond(damage.base + data.extra, data)
                    end)
                }
            }
        },
        ['Slam'] = {
            ["name"] = "Slam",
            ["id"] = 11605,
            [11605] = {
                ["rank"] = 4,
                ["data"] = {
                    extra = 87,
                    lowerBound = 0,
                    upperBound = 0,
                    rageCost = 15,
                    castTime = 0,
                    mod = 0,
                    cooldown = { standard = 10, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        return round(mainHandDamage.base, 2) + data.extra;
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        return round((mainHandDamage.base + data.extra) * critModifier, 2);
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local damage = Utils:MainHandDamage()
                        return Utils:DamagePerPowerCost(damage.base + data.extra, data.rageCost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        local damage = Utils:MainHandDamage()
                        return Utils:DamagePerSecond(damage.base + data.extra, data)
                    end)
                }
            }
        },
        ['Whirlwind'] = {
            ["name"] = "Whirlwind",
            ["id"] = 1680,
            [1680] = {
                ["rank"] = 0,
                ["data"] = {
                    lowerBound = 0,
                    upperBound = 0,
                    rageCost = 25,
                    castTime = 0,
                    mod = 0,
                    cooldown = { standard = 10, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        return round(mainHandDamage.base, 2);
                        --                        return self:DefaultDamageCalculationAmount(data)
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        return round(mainHandDamage.base * critModifier, 2);
                        --                        return self:DefaultCritDamageCalculationAmount(data, critModifier)
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local damage = Utils:MainHandDamage()
                        return Utils:DamagePerPowerCost(damage.base, data.rageCost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        local damage = Utils:MainHandDamage()
                        return Utils:DamagePerSecond(damage.base, data)
                    end)
                }
            }
        },
        ['Shield Slam'] = {
            ["name"] = "Shield Slam",
            ["id"] = 23923,
            [23923] = {
                ["rank"] = 2,
                ["data"] = {
                    lowerBound = 264,
                    upperBound = 276,
                    rageCost = 20,
                    castTime = 0,
                    mod = 0,
                    cooldown = { standard = 6, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        self:getBlockValue(data)
                        return string.format("%s (%s - %s)",
                            Utils:DefaultDamageCalculationAmount(data), (data.lowerBound),
                            (data.upperBound))
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return string.format("%s (%s - %s)",
                            Utils:DefaultCritDamageCalculationAmount(data, critModifier),
                            (data.lowerBound * critModifier),
                            (data.upperBound * critModifier))
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local baseDamage = Utils:DefaultDamageCalculationAmount(data)
                        return Utils:DamagePerPowerCost(baseDamage, data.rageCost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        local baseDamage = Utils:DefaultDamageCalculationAmount(data)
                        return Utils:DamagePerSecond(baseDamage, data)
                    end)
                }
            }
        },
        ['Bloodthirst'] = {
            ["name"] = "Bloodthirst",
            [23881] = {
                ["rank"] = 1,
                ["data"] = {
                    lowerBound = 0,
                    upperBound = 0,
                    rageCost = 30,
                    castTime = 0,
                    mod = 0.45,
                    cooldown = { standard = 6, gcd = 1.5 }
                },
            },
            [23892] = {
                ["rank"] = 2,
                ["data"] = {
                    lowerBound = 0,
                    upperBound = 0,
                    rageCost = 30,
                    castTime = 0,
                    mod = 0.45,
                    cooldown = { standard = 6, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Physical" } },
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
                        local baseDamage = Utils:DefaultDamageCalculationAmount(data)
                        return Utils:DamagePerSecond(baseDamage, data)
                    end)
                }
            }
        },
        ['Rend'] = {
            ["name"] = "Rend",
            [11574] = {
                ["rank"] = 7,
                ["data"] = {
                    dot = { total = 147, duration = 21, interval = 3 },
                    lowerBound = 0,
                    upperBound = 0,
                    rageCost = 10,
                    castTime = 0,
                    mod = 0,
                    cooldown = { standard = 0, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Damage per tick",
                    type = 'Damage',
                    calculation = (function(data)
                        local _, _, _, _, currentRank, _, _, _ = GetTalentInfo(1, 3);
                        local base = {}
                        base[1] = 15
                        base[2] = 25
                        base[3] = 35

                        local damage = data.dot.total
                        if (currentRank > 0) then
                            damage = data.dot.total * (1 + (base[currentRank] / 100))
                        end
                        return (damage / data.dot.duration) * data.dot.interval
                    end)
                }
            }
        }
    }
end
