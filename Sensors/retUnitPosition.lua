local sensorInfo = {
    name = "retUnitPosition",
    desc = "Vec3 of unit's position",
    author = "Petrroll",
    date = "2018-06-29",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

local SpringGetUnitPosition = Spring.GetUnitPosition

-- @description return Vec3 of unit's position
return function(uid)
    if uid == nil then return nil end
    
    return Vec3(SpringGetUnitPosition(uid)) 
end