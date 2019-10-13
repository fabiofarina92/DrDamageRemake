-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "SHAMAN" then return end

function DrDamageRemake:PlayerData()
    self.classColour = '003cff'
    self.spellInfo = {
    }
end
