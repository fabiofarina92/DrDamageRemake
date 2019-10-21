-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "PRIEST" then return end
local critModifier = 1.5
local Utils = DrDamageRemake

function DrDamageRemake:PlayerData()
    self.classColour = 'e3e3e3'
    self.spellInfo = {
        ['Smite'] = {
            ["name"] = "Smite",
            [585] = {
                ["rank"] = 1,
                ["data"] = {
                    lowerBound = 13,
                    upperBound = 17,
                    cost = 20,
                    castTime = 1.5,
                    mod = 0.10,
                    cooldown = { standard = 0, gcd = 1.5 }
                },
            },
            ["info"] = {school = {"Holy"}},
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
