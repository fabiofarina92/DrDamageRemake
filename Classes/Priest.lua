-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "PRIEST" then return end

function DrDamageRemake:PlayerData()
    self.classColour = 'e3e3e3'
    self.spellInfo = {
    }
end
