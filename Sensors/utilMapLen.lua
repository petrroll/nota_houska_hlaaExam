local sensorInfo = {
    name = "utilMapLen",
    desc = "Returns number of paris in map",
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

local SensorsGetUnitPosition = Sensors.GetUnitPosition

-- @description Returns number of paris in map
return function(map)
    -- # for getting length wasn't always reliable

    local len = 0
    for _, _ in pairs(map) do
        len = len + 1
    end
    
    return len
end