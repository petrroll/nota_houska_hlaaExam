local sensorInfo = {
    name = "filterUnitsOutsideOfArea",
    desc = "Returns units outside of an area",
    author = "Petrroll",
    date = "2018-06-29",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching
local DISTANCE_CLOSE_ENOUGH = 500

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

local SensorsGetUnitPosition = Sensors.GetUnitPosition

-- @description returns units outside of an area
return function(units, loc, distance)
    local outsideUnits = {}

    for i = 1, #units do
        local uid = units[i]
        local pos = Sensors.retUnitPosition(uid)

        if (pos ~= nil and pos:Distance(loc) > distance) then
            outsideUnits[#outsideUnits + 1] = uid
        end
    end

    return outsideUnits
end