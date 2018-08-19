local sensorInfo = {
    name = "getPosRelativeToFront",
    desc = "Gets Position relative to the front on lane",
    author = "Petrroll",
    date = "2018-06-28",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

-- @description returns first safe location at front with reclaimable metal.
return function(laneInfo, radius, relIndexBeforeFront)

    local pointsOnLane = laneInfo.corridor.points
    local front = laneInfo.frontPosIndex

    for i = 1, #pointsOnLane do 
        if i + relIndexBeforeFront > front then break end

        if Sensors.retReclaimableAtLoc(pointsOnLane[i].position, radius) > 0 then
            return pointsOnLane[i].position
        end

    end

    return nil
end