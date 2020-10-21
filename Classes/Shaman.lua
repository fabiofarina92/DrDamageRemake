-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "SHAMAN" then return end
local critModifier = 1.5
local Utils = DrDamageRemake

function DrDamageRemake:PlayerData()
    self.classColour = '003cff'
    self.spellInfo = {
        ['Lightning Bolt'] = {
            ["name"] = "Lightning Bolt",
            ["match"] = {
                ["damageRange"] = '(%d+) to (%d+)',
                ["cooldown"] = '(%d+) sec cooldown',
                ["cost"] = '(%d+) Mana'
            },
            ["data"] = {
                mod = 0.10,
                cooldown = { standard = 0, gcd = 1.5 },
                level = { min = 1, max = 5 },
            },
            ["info"] = { school = { "Nature" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local amount = Utils:DefaultSpellDamageCalculationAmount(data.lowerBound, data.upperBound, data.mod)
                        return string.format("%s (%s - %s)", amount, data.lowerBound,
                            data.upperBound)
                    end)
                },
            }
        },
        ['Earth Shock'] = {
            ["name"] = "Earth Shock",
            ["match"] = {
                ["damageRange"] = '(%d+) to (%d+)',
                ["cooldown"] = '(%d+) sec cooldown',
                ["cost"] = '(%d+) Mana'
            },
            ["data"] = {
                mod = 0.10,
                cooldown = { standard = 0, gcd = 1.5 },
                level = { min = 1, max = 5 },
            },
            ["info"] = { school = { "Nature" } },
            ["toolTipData"] = {
                [1] = {
                    label = "Average",
                    type = 'Damage',
                    calculation = (function(data)
                        local amount = Utils:DefaultSpellDamageCalculationAmount(data.lowerBound, data.upperBound, data.mod)
                        return string.format("%s (%s - %s)", amount, data.lowerBound,
                            data.upperBound)
                    end)
                },
            }
        }
    }
end
