-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "DRUID" then return end

function DrDamageRemake:PlayerData()
    self.classColour = 'ff752b'
    self.spellInfo = {
    }
end
