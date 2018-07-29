local sensorInfo = {
    name = "filterUnitsInDanger",
    desc = "Returns units that aren't safe",
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

local utilSplitMapByPredicate = Sensors.utilSplitMapByPredicate
local isInDanger = Sensors.isInDanger

-- @description returns units that aren't safe
return function(units, safeRadius, DPSTreshold)
    local outsideUnits = {}

    local predicate = function(uid) 
        return isInDanger(uid, safeRadius, DPSTreshold)
    end

    local splitResult = utilSplitMapByPredicate(units, predicate)
    return splitResult
end