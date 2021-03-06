local sensorInfo = {
    name = "filterUnitsOutsideOfArea",
    desc = "Returns units outside of an area",
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

local retUnitPosition = Sensors.retUnitPosition
local utilSplitMapByPredicate = Sensors.utilSplitMapByPredicate

-- @description returns units outside of an area
return function(units, loc, distance)
    local outsideUnits = {}

    local predicate = function(uid) 
        local pos = retUnitPosition(uid)
        return (pos ~= nil and pos:Distance(loc) > distance)
    end

    local splitResult = utilSplitMapByPredicate(units, predicate)
    return splitResult
end