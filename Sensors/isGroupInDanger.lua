local sensorInfo = {
    name = "isGroupInDanger",
    desc = "Returns whether a group of units is in danger",
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


local isInDanger = Sensors.isInDanger

-- @description Returns whether a group of units is in danger
return function(units, radius, dpsTreshold, unitsInDangerRatioTreshold)
    local unitsNB = #units
    local unitsInDangerNB = 0

    for i = 1, #units do
        if isInDanger(units[i], radius, dpsTreshold) then
            unitsInDangerNB = unitsInDangerNB + 1
        end
    end

    return (unitsInDangerNB / unitsNB) > unitsInDangerRatioTreshold
end