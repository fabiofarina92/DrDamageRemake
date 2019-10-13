-- Short circuit to prevent loading non-needed data
if select(2, UnitClass("player")) ~= "HUNTER" then return end

function DrDamageRemake:PlayerData()
    self.classColour = '1df52f'
    self.spellInfo = {
    }
end
