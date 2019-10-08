if select(2, UnitClass("player")) ~= "PALADIN" then return end
local GetSpellBonusHealing = GetSpellBonusHealing
local GetManaRegen = GetManaRegen
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
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
    return string.format("%s (%s - %s)", calculation, (data.lowerBound * critModifier),
                         (data.upperBound * critModifier))
end

function castCountUntilOom(data)
    local castCount = math.floor(UnitPowerMax("player", 0) / data.manaCost)
    return castCount
end

function totalHealingUntilOom(data)
    return defaultHealingCalculationAmount(data) * castCountUntilOom(data)
end

function DrDamageRemake:PlayerData()
    self.spellInfo = {
        [635] = {
            ["name"] = "Holy Light",
            ["id"] = 635,
            ["rank"] = 1,
            ["data"] = {lowerBound = 42, upperBound = 51, manaCost = 35},
            ["info"] = {school = {"Holy"}, type = "Heal"},
            ["toolTipData"] = {
                ["avg"] = {
                    property = "Average",
                    calculation = (function(data)
                        return defaultHealingCalculation(data)
                    end)
                },
                ["crit"] = {
                    property = "Critical",
                    calculation = (function(data)
                        return defaultHealingCritCalculation(data)
                    end)
                },
                ["castTilOom"] = {
                    property = "Casts until oom",
                    calculation = (function(data)
                        return castCountUntilOom(data)
                    end)
                },
                ["totalTilOom"] = {
                    property = "Total until oom",
                    calculation = (function(data)
                        return totalHealingUntilOom(data)
                    end)
                }
            }

        },
        [639] = {
            ["name"] = "Holy Light",
            ["id"] = 639,
            ["rank"] = 2,
            ["data"] = {lowerBound = 79, upperBound = 94, manaCost = 60},
            ["info"] = {school = {"Holy"}, type = "Heal"},
            ["toolTipData"] = {
                ["avg"] = {
                    property = "Average",
                    calculation = (function(data)
                        return defaultHealingCalculation(data)
                    end)
                },
                ["crit"] = {
                    property = "Critical",
                    calculation = (function(data)
                        return defaultHealingCritCalculation(data)
                    end)
                },
                ["castTilOom"] = {
                    property = "Casts until oom",
                    calculation = (function(data)
                        return castCountUntilOom(data)
                    end)
                },
                ["totalTilOom"] = {
                    property = "Total until oom",
                    calculation = (function(data)
                        return totalHealingUntilOom(data)
                    end)
                }
            }
        }
    }
end
