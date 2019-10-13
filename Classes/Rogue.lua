-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "ROGUE" then return end

function DrDamageRemake:PlayerData()
    self.classColour = 'eeff00'
    self.spellInfo = {
    }
end
