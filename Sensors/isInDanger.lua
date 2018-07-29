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

-- @description returns whether unit is in danger
return function(uid, radius, treshold)
    local unitLoc = retUnitPosition(uid)
    local DPSRatio = Sensors.retAreaDPSRatio(unitLoc, radius)

    return DPSRatio < treshold
end