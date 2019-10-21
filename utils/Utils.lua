local UnitAttackPower = UnitAttackPower
local UnitAttackSpeed = UnitAttackSpeed
local UnitDamage = UnitDamage
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

function DrDamageRemake:DamagePerPowerCost(damage, cost)
    return round(damage / cost, 2)
end

function DrDamageRemake:DamagePerSecond(damage, data)
    local castsPerMinute = self:CastsPerMinute(data)

    local totalDamagePerMinute = castsPerMinute *
            damage
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

function DrDamageRemake:MainHandDamage()
    local speed, _ = UnitAttackSpeed("player")
    local minDamage, maxDamage, _, _, physicalBonusPos, physicalBonusNeg, percent = UnitDamage("player")
    local damageSpread = max(floor(minDamage), 1) .. " - " .. max(ceil(maxDamage), 1)

    local baseDamage = (minDamage + maxDamage) * 0.5
    local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent
    local damagePerSecond = (max(fullDamage, 1) / speed)

    return { min = minDamage, max = maxDamage, base = baseDamage, full = fullDamage, dps = damagePerSecond, spread = damageSpread }
end

function DrDamageRemake:OffHandDamage()
    local _, offhandSpeed = UnitAttackSpeed("player");
    if (offhandSpeed) then
        local _, _, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage("player");
        local damageSpread = max(floor(minOffHandDamage), 1) .. " - " .. max(ceil(maxOffHandDamage), 1);
        local offhandBaseDamage = (minOffHandDamage + maxOffHandDamage) * 0.5;
        local offhandFullDamage = (offhandBaseDamage + physicalBonusPos + physicalBonusNeg) * percent;
        --		local totalBonus = (offhandFullDamage - offhandBaseDamage);
        local offhandDamagePerSecond = (max(offhandFullDamage, 1) / offhandSpeed);

        return { min = minOffHandDamage, max = maxOffHandDamage, base = offhandBaseDamage, full = offhandFullDamage, dps = offhandDamagePerSecond, spread = damageSpread }
    end
end
