local sensorInfo = {
    name = "getUnitDPS",
    desc = "Returns unit's DPS",
    author = "Petrroll",
    date = "2018-07-28",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching
local UNKNOWN_EST = 50

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

local SpringGetUnitDefID = Spring.GetUnitDefID
local dpsPerUnitDefId = {}
local dpsPerUnitId = {}

-- @description return current wind statistics
return function(unit)
    if unit == nil then return 0 end

    if dpsPerUnitId[unit] ~= nil then
        return dpsPerUnitId[unit]
    end

    -- unit definition
    local unitDefId = SpringGetUnitDefID(unit)
    if not unitDefId then 
        return UNKNOWN_EST
    end



    if dpsPerUnitDefId[unitDefId] ~= nil then
        dpsPerUnitId[unit] = dpsPerUnitDefId[unitDefId]
        return dpsPerUnitDefId[unitDefId]
    end

    -- unit's weapons
    local unitDef = UnitDefs[unitDefId]
    if not unitDef.weapons or #unitDef.weapons < 1 then 
        dpsPerUnitDefId[unitDefId] = 0
        dpsPerUnitId[unit] = 0
        return 0
    end

    -- weapon definition
    local weaponDefId = unitDef.weapons[1].weaponDef 
    if not weaponDefId then 
        dpsPerUnitDefId[unitDefId] = 0
        dpsPerUnitId[unit] = 0
        return 0
    end

    -- weapon properties
    local weapon = WeaponDefs[weaponDefId]
    if not weapon then 
        dpsPerUnitDefId[unitDefId] = UNKNOWN_EST
        dpsPerUnitId[unit] = UNKNOWN_EST
        return UNKNOWN_EST
    end

    dpsPerUnitDefId[unitDefId] = weapon.damages[0] / weapon.reload
    dpsPerUnitId[unit] = dpsPerUnitDefId[unitDefId]

    return dpsPerUnitId[unit]
end