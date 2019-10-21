if select(2, UnitClass("player")) ~= "PALADIN" then return end
local GetSpellBonusHealing = GetSpellBonusHealing
local GetManaRegen = GetManaRegen
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local GetSpellCritChance = GetSpellCritChance
local critModifier = 1.5

function defaultHealingCalculationAmount(data)
    local average = math.floor((data.lowerBound + data.upperBound) / 2)
    local modifiers = GetSpellBonusHealing() * 0.1
    local calculation = average + modifiers
    return calculation
end

function defaultHealingCritCalculationAmount(data)
    return defaultHealingCalculationAmount(data) * critModifier
end

function defaultHealingCalculation(data)
    local calculation = defaultHealingCalculationAmount(data)
    return string.format("%s (%s - %s)", calculation, data.lowerBound,
        data.upperBound)
end

function defaultHealingCritCalculation(data)
    local calculation = defaultHealingCritCalculationAmount(data)
    return string.format("%s (%s - %s)", calculation,
        (data.lowerBound * critModifier),
        (data.upperBound * critModifier))
end

function castCountUntilOom(data)
    local castCount = math.floor(UnitPowerMax("player", 0) / data.manaCost)
    return castCount
end

function totalHealingUntilOom(data)
    return defaultHealingCalculationAmount(data) * castCountUntilOom(data)
end

function healingPerMana(data)
    local calculation = defaultHealingCalculationAmount(data)
    return round(calculation / data.manaCost, 2)
end

function healingPerSecond(data)
    return round(defaultHealingCalculationAmount(data) / data.castTime, 2)
end

function DrDamageRemake:PlayerData()
    self.classColour = 'f542c8'
    self.spellInfo = {
        ['Holy Light'] = {
            ["name"] = "Holy Light",
            [635] = {
                ["rank"] = 1,
                ["data"] = {
                    lowerBound = 42,
                    upperBound = 51,
                    manaCost = 35,
                    castTime = 2.5
                },
            },
            [639] = {
                ["rank"] = 1,
                ["data"] = {
                    lowerBound = 79,
                    upperBound = 94,
                    manaCost = 60,
                    castTime = 2.5
                },
            },
            ["info"] = { school = { "Holy" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Heal',
                    calculation = (function(data)
                        return defaultHealingCalculation(data)
                    end)
                },
                [2] = {
                    label = "Average Crit",
                    type = 'Heal',
                    calculation = (function(data)
                        return defaultHealingCritCalculation(data)
                    end)
                },
                [3] = {
                    label = "Casts",
                    type = 'Mana',
                    calculation = (function(data)
                        return castCountUntilOom(data)
                    end)
                },
                [4] = {
                    label = "Heal until OOM",
                    type = 'Mana',
                    calculation = (function(data)
                        return totalHealingUntilOom(data)
                    end)
                },
                [5] = {
                    label = "HPM",
                    type = 'Mana',
                    calculation = (function(data)
                        return healingPerMana(data)
                    end)
                },
                [6] = {
                    label = "HPS",
                    type = 'Heal',
                    calculation = (function(data)
                        return healingPerSecond(data)
                    end)
                },
                [7] = {
                    label = "Crit",
                    type = 'Stat',
                    calculation = (function(data)
                        return string.format("%.2f%%", GetSpellCritChance())
                    end)
                },
                [8] = {
                    label = "HP",
                    type = 'Stat',
                    calculation = (function(data)
                        return string.format("%.0f", GetSpellBonusHealing())
                    end)
                }
            }
        },
    }
end
