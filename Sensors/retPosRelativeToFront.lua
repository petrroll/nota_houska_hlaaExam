local sensorInfo = {
    name = "retPosRelativeToFront",
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

local function getPointForIndex(points, posIndex)
    if posIndex > #points then posIndex = #points
    elseif posIndex < 1 then posIndex = 1 end

    return points[posIndex].position
end

-- @description Gets Position relative to the front on lane
return function(laneInfo, relativeIndex)
    local points = laneInfo.corridor.points

    local closerIndex = math.floor(relativeIndex) + laneInfo.frontPosIndex
    local closerPoint = getPointForIndex(points, closerIndex)

    local furtherIndex = math.ceil(relativeIndex) + laneInfo.frontPosIndex
    local furtherPoint = getPointForIndex(points, furtherIndex)

    local ratio = math.abs(math.floor(relativeIndex) - relativeIndex)
    return closerPoint * (1-ratio) + furtherPoint * ratio
end