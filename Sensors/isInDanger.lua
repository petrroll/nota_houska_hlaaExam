local sensorInfo = {
    name = "isInDanger",
    desc = "Returns whether unit is in danger",
    author = "Petrroll",
    date = "2018-07-29",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end


local retUnitPosition = Sensors.retUnitPosition
local retAreaDPSRatio = Sensors.retAreaDPSRatio
local SpringGetProjectilesInRectangle = Spring.GetProjectilesInRectangle

-- @description returns whether unit is in danger
return function(uid, radius, treshold)
    local unitLoc = retUnitPosition(uid)

    local projectilesRec = 40
    local projectilesInArea = SpringGetProjectilesInRectangle(unitLoc.x - projectilesRec, unitLoc.z - projectilesRec, 
                                                                unitLoc.x + projectilesRec, unitLoc.z + projectilesRec)

    -- returned only a number 
    if #projectilesInArea > 0 then
        return true
    end
    
    local DPSRatio = Sensors.retAreaDPSRatio(unitLoc, radius)
    return DPSRatio < treshold
end