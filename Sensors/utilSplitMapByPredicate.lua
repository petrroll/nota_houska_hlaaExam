local sensorInfo = {
    name = "utilSplitMapByPredicate",
    desc = "Splits lua map by a predicate",
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

-- @description splits lua map by a predicate
return function(map, predicate)
    
    local trueMap = {}
    local falseMap = {}

    for i = 1, #map do
 
        local predResult = predicate(map[i])

        -- nil results are discarted 
        if predResult ~= nil then 
            if predResult then trueMap[#trueMap + 1] = map[i] 
            else falseMap[#falseMap + 1] = map[i] end
        end

    end
    
    return {t = trueMap, f=falseMap}
end