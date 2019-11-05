-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "SHAMAN" then return end
local critModifier = 1.5
local Utils = DrDamageRemake

function DrDamageRemake:PlayerData()
    self.classColour = '003cff'
    self.spellInfo = {
        ['Lightning Bolt'] = {
            ["name"] = "Lightning Bolt",
            [403] = {
                ["rank"] = 1,
                ["data"] = {
                    lowerBound = 12,
                    upperBound = 15,
                    cost = 15,
                    castTime = 1.5,
                    mod = 0.10,
                    cooldown = { standard = 0, gcd = 1.5 },
                    level = { min = 1, max = 5 }
                },
            },
            [529] = {
                ["rank"] = 2,
                ["data"] = {
                    lowerBound = 26,
                    upperBound = 30,
                    cost = 30,
                    castTime = 2.0,
                    mod = 0.10,
                    cooldown = { standard = 0, gcd = 1.5 },
                    level = { min = 1, max = 5 }
                },
            },
            ["info"] = { school = { "Nature" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local range = Utils:GetSpellDamageRange(data.level.min, data.level.max, data.lowerBound, data.upperBound)
                        local amount = Utils:DefaultSpellDamageCalculationAmount(range.newLower, range.newUpper, data.mod)
                        return string.format("%s (%s - %s)", amount, range.newLower,
                            range.newUpper)
                    end)
                },
                [2] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local range = Utils:GetSpellDamageRange(data.level.min, data.level.max, data.lowerBound, data.upperBound)
                        local amount = Utils:DefaultSpellDamageCalculationAmount(range.newLower, range.newUpper, data.mod)
                        local critAmount = Utils:DefaultSpellCritDamageCalculationAmount(amount, critModifier)
                        return string.format("%s (%s - %s)", critAmount, data.lowerBound * critModifier,
                            data.upperBound * critModifier)
                    end)
                },
            }
        }
    }
end
