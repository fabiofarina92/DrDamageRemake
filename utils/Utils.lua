local UnitAttackPower = UnitAttackPower
local GetSpellBonusHealing = GetSpellBonusHealing
local GetSpellBonusDamage = GetSpellBonusDamage
local GetManaRegen = GetManaRegen
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local GetSpellCritChance = GetSpellCritChance
local math_floor = math.floor

function DrDamageRemake:GetCurrentAttackPower(baseAp)
    local base, posBuff, negBuff = UnitAttackPower("player")
    if baseAp then
        return base
    end

    local totalAttackPower = base + posBuff + negBuff

    return totalAttackPower
end

function DrDamageRemake:DefaultDamageCalculationAmount(data)
    local average = math_floor((data.lowerBound + data.upperBound) / 2)
    local modifiers = self:GetCurrentAttackPower() * data.mod
    local calculation = average + modifiers
    return calculation
end

function DrDamageRemake:DefaultCritDamageCalculationAmount(data, critModifier)
    return self:DefaultDamageCalculationAmount(data) * critModifier
end

function DrDamageRemake:DamagePerPowerCost(data, cost)
    return self:DefaultDamageCalculationAmount(data) / cost
end

function DrDamageRemake:DamagePerSecond(data)
    local castsPerMinute = self:CastsPerMinute(data)

    local totalDamagePerMinute = castsPerMinute *
                                     self:DefaultDamageCalculationAmount(data)
    return round(totalDamagePerMinute / 60, 2)
end

function DrDamageRemake:CastsPerMinute(data)
    local castsPerMinute = 0
    if data.cooldown.gcd > data.cooldown.standard then
        castsPerMinute = 60 / data.cooldown.gcd
    else
        castsPerMinute = 60 / data.cooldown.standard
    end
    return castsPerMinute
end

function DrDamageRemake:DamagePerSecondCalc(castsPerMinute, damage)
    local totalDamagePerMinute = castsPerMinute * damage
    return round(totalDamagePerMinute / 60, 2)
end