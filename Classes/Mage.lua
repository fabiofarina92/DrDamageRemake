-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "MAGE" then return end
local Utils = DrDamageRemake

function DrDamageRemake:PlayerData()
    self.classColour = '3ff6fc'
    self.spellInfo = {
        ['Frostbolt'] = {
            ["name"] = "Frostbolt",
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
            ["info"] = { school = { "frost" } },
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
                [2] = {
                    label = "Crit",
                    type = 'Damage',
                    calculation = (function(data)
                        local normalAmount = Utils:DefaultSpellDamageCalculationAmount(data.lowerBound, data.upperBound, data.mod)
                        local critAmount = Utils:DefaultSpellCritDamageCalculationAmount(normalAmount, 2)
                        return string.format("%s (%s - %s)", critAmount, data.lowerBound * 2,
                            data.upperBound * 2)
                    end)
                },
            }
        },
    }
end
