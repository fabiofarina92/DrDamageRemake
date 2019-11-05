-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "WARLOCK" then return end
local critModifier = 1.5
local Utils = DrDamageRemake

function DrDamageRemake:PlayerData()
    self.classColour = '003cff'
    self.spellInfo = {
        ['Shadow Bolt'] = {
            ["name"] = "Shadow Bolt",
            [686] = {
                ["rank"] = 1,
                ["data"] = {
                    lowerBound = 12,
                    upperBound = 16,
                    cost = 25,
                    castTime = 1.7,
                    mod = 0.10,
                    cooldown = { standard = 0, gcd = 1.5 }
                },
            },
            ["info"] = { school = { "Shadow" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local amount = Utils:DefaultDamageCalculationAmount(data)
                        return string.format("%s (%s - %s)", amount, data.lowerBound,
                            data.upperBound)
                    end)
                },
                [2] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local amount = Utils:DefaultCritDamageCalculationAmount(data, critModifier)
                        return string.format("%s (%s - %s)", amount, data.lowerBound * critModifier,
                            data.upperBound * critModifier)
                    end)
                },
            }
        }
    }
end
