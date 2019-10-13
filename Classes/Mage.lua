-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "MAGE" then return end

function DrDamageRemake:PlayerData()
    self.classColour = '3ff6fc'
    self.spellInfo = {
    }
end
