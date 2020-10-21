if select(2, UnitClass("player")) ~= "WARRIOR" then return end
local UnitStat = UnitStat
local GetInventoryItemLink = GetInventoryItemLink
local GetShapeshiftForm = GetShapeshiftForm
local critModifier = 2.0

local normalisedSpeedDaggers = 1.7
local normalisedSpeedOneHander = 2.4
local normalisedSpeedTwoHander = 3.3

local Utils = DrDamageRemake

--function DrDamageRemake:getBlockValue(data)
--    local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 1)
--
--    local strength = stat + posBuff + negBuff
--
--    local stats = GetItemStats(GetInventoryItemLink("player", 17))
--end

function DrDamageRemake:PlayerData()
    self.classColour = 'bf5d39'
    self.spellInfo = {
        ['Hamstring'] = {
            ["match"] = {
                ["damage"] = 'causing (%d+) damage',
                ["cooldown"] = '(%d+) sec cooldown',
                ["cost"] = '(%d+) Rage'
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        return string.format("%s",
                            Utils:DefaultDamageCalculationAmount(data))
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return string.format("%s",
                            Utils:DefaultCritDamageCalculationAmount(data, critModifier))
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local baseDamage = Utils:DefaultDamageCalculationAmount(data)
                        return Utils:DamagePerPowerCost(baseDamage, data.cost)
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
        ['Mocking Blow'] = {
            ["match"] = {
                ["damage"] = 'causes (%d+) damage',
                ["cooldown"] = '(%d+) sec cooldown',
                ["cost"] = '(%d+) Rage'
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        return string.format("%s",
                            Utils:DefaultDamageCalculationAmount(data))
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        return string.format("%s",
                            Utils:DefaultCritDamageCalculationAmount(data, critModifier))
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local baseDamage = Utils:DefaultDamageCalculationAmount(data)
                        return Utils:DamagePerPowerCost(baseDamage, data.cost)
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
        ['Execute'] = {
            ["match"] = {
                ["extra"] = 'rage into (%d+)',
                ["damage"] = 'causing (%d+) damage',
                ["cost"] = '(%d+) Rage',
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average at 15 rage",
                    type = 'Damage',
                    calculation = (function(data)
                        local rage = 15
                        local amount = data.damage + (data.extra * (rage - data.cost));
                        return string.format('%s (%s)', amount, amount * critModifier)
                    end)
                },
                [2] = {
                    label = "Average at 30 rage",
                    type = 'Damage',
                    calculation = (function(data)
                        local rage = 30
                        local amount = data.damage + (data.extra * (rage - data.cost));
                        return string.format('%s (%s)', amount, amount * critModifier)
                    end)
                },
                [3] = {
                    label = "Average at 45 rage",
                    type = 'Damage',
                    calculation = (function(data)
                        local rage = 45
                        local amount = data.damage + (data.extra * (rage - data.cost));
                        return string.format('%s (%s)', amount, amount * critModifier)
                    end)
                },
                [4] = {
                    label = "Average at 60 rage",
                    type = 'Damage',
                    calculation = (function(data)
                        local rage = 60
                        local amount = data.damage + (data.extra * (rage - data.cost));
                        return string.format('%s (%s)', amount, amount * critModifier)
                    end)
                },
                [5] = {
                    label = "Average at 100 rage",
                    type = 'Damage',
                    calculation = (function(data)
                        local rage = 100
                        local amount = data.damage + (data.extra * (rage - data.cost));
                        return string.format('%s (%s)', amount, amount * critModifier)
                    end)
                },
                [6] = {
                    label = "Average at current rage",
                    type = 'Damage',
                    calculation = (function(data)
                        local rage = UnitPower('player');
                        if rage < data.cost then
                            return 'Insufficient rage'
                        end
                        local amount = data.damage + (data.extra * (rage - data.cost));
                        return string.format('%s (%s)', amount, amount * critModifier)
                    end)
                },
            }
        },
        ['Overpower'] = {
            ["match"] = {
                ["extra"] = 'damage plus (%d+)',
                ["cost"] = '(%d+) Rage',
                ["cooldown"] = '(%d+) sec cooldown'
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return round(damageCalculation, 2) + data.extra;
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return round(damageCalculation * critModifier, 2);
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return Utils:DamagePerPowerCost(damageCalculation, data.cost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return Utils:DamagePerSecond(damageCalculation, data)
                    end)
                }
            }
        },
        ['Heroic Strike'] = {
            ["match"] = {
                ["extra"] = 'damage by (%d+)',
                ["cost"] = '(%d+) Rage'
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
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
                        return Utils:DamagePerPowerCost(damage.base + data.extra, data.cost)
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
            ["match"] = {
                ["extra"] = 'damage plus (%d+)',
                ["cost"] = '(%d+) Rage',
                ["cast"] = '(%d+) sec cast'
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
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
                        return Utils:DamagePerPowerCost(damage.base + data.extra, data.cost)
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
        ['Mortal Strike'] = {
            ["name"] = "Mortal Strike",
            ["match"] = {
                ["extra"] = 'damage plus (%d+)',
                ["cost"] = '(%d+) Rage',
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 6, gcd = 1.5 }
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return round(damageCalculation, 2);
                        --                        return self:DefaultDamageCalculationAmount(data)
                    end)
                },
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return round(damageCalculation * critModifier, 2);
                        --                        return self:DefaultCritDamageCalculationAmount(data, critModifier)
                    end)
                },
                [3] = {
                    label = "DPR",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return Utils:DamagePerPowerCost(damageCalculation, data.cost)
                    end)
                },
                [4] = {
                    label = "DPS",
                    type = 'Damage',
                    calculation = (function(data)
                        local mainHandDamage = Utils:MainHandDamage()
                        local damageCalculation = mainHandDamage.base + data.extra + (Utils:GetCurrentAttackPower() / 14) * normalisedSpeedTwoHander
                        return Utils:DamagePerSecond(damageCalculation, data)
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
                    cost = 25,
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
                        return Utils:DamagePerPowerCost(damage.base, data.cost)
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
        ['Revenge'] = {
            ["match"] = {
                ["damageRange"] = '(%d+) to (%d+)',
                ["cooldown"] = '(%d+) sec cooldown',
                ["cost"] = '(%d+) Rage'
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
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
                        return Utils:DamagePerPowerCost(baseDamage, data.cost)
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
        ['Shield Slam'] = {
            ["match"] = {
                ["damageRange"] = '(%d+) to (%d+)',
                ["cooldown"] = '(%d+) sec cooldown',
                ["cost"] = '(%d+) Rage'
            },
            ["data"] = {
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
            },
            ["info"] = { school = { "Physical" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
--                        self:getBlockValue(data)
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
                        return Utils:DamagePerPowerCost(baseDamage, data.cost)
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
                    cost = 30,
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
                    cost = 30,
                    castTime = 0,
                    mod = 0.45,
                    cooldown = { standard = 6, gcd = 1.5 }
                },
            },
            [23894] = {
                ["rank"] = 4,
                ["data"] = {
                    lowerBound = 0,
                    upperBound = 0,
                    cost = 30,
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
                                data.mod) / data.cost
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
            ["match"] = {
                ["damageOverTime"] = '(%d+) damage over (%d+)',
                ["cost"] = '(%d+) Rage'
            },
            ["data"] = {
                dot = { total = 147, duration = 21, interval = 3 },
                castTime = 0,
                mod = 0,
                cooldown = { standard = 0, gcd = 1.5 }
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
