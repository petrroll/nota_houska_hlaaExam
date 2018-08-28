local sensorInfo = {
    name = "utilMapAny",
    desc = "Returns whether map is empty or not",
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

local next = next 
-- @description Returns whether map is empty or not (#map > 0 wasn't always reliable)
return function(map)
    return not (next(map) == nil) 
end