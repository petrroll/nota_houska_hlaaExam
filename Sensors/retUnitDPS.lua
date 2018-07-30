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

-- @description return current wind statistics
return function(unit)
    if unit == nil then return 0 end

    -- unit definition
    local unitDefId = SpringGetUnitDefID(unit)
    if not unitDefId then return UNKNOWN_EST end

    -- unit's weapons
    local unitDef = UnitDefs[unitDefId]
    if not unitDef.weapons or #unitDef.weapons < 1 then return 0 end

    -- weapon definition
    local weaponDefId = unitDef.weapons[1].weaponDef 
    if not weaponDefId then return 0 end

    -- weapon properties
    local weapon = WeaponDefs[weaponDefId]
    if not weapon then return UNKNOWN_EST end

    return weapon.damages[0] / weapon.reload
end