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

-- @description Gets Position relative to the front on lane
return function(laneInfo, relativeIndex)

    local posIndex = laneInfo.frontPosIndex + relativeIndex

    if posIndex > #laneInfo.points then posIndex =  #laneInfo.points
    elseif posIndex < 1 then posIndex = 1 end

    return laneInfo.points[posIndex]
    
end