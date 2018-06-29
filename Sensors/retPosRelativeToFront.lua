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

local function getPointForIndex(laneInfo, posIndex)
    if posIndex > #laneInfo.points then posIndex = #laneInfo.points
    elseif posIndex < 1 then posIndex = 1 end

    return laneInfo.points[posIndex]
end

-- @description Gets Position relative to the front on lane
return function(laneInfo, relativeIndex)

    local closerIndex = math.floor(relativeIndex) + laneInfo.frontPosIndex
    local closerPoint = getPointForIndex(laneInfo, closerIndex)

    local furtherIndex = math.ceil(relativeIndex) + laneInfo.frontPosIndex
    local furtherPoint = getPointForIndex(laneInfo, furtherIndex)

    local ratio = math.abs(math.floor(relativeIndex) - relativeIndex)
    return closerPoint * (1-ratio) + furtherPoint * ratio
end