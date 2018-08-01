local sensorInfo = {
    name = "osGetUnitTypeForOrderToMaintainRatio",
    desc = "Creates order info for a unit type that is needed to maintain a specified units ratio.",
    author = "Petrroll",
    date = "2018-07-31",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

local SpringGetMyTeamID = Spring.GetMyTeamID
local SpringGetTeamResources = Spring.GetTeamResources
local teamID = SpringGetMyTeamID()
local getTeamMetal = Sensors.getTeamMetal

-- @description creates order info for a unit type that is needed to maintain a specified units ratio
return function(unitsInfo, ratioConfig)

    -- ratioConfig: {.categoryName, .ratio, .unitName}
    local units = 0
    local unitsByCategory = {}
    local unitsDesiredRatios = {}
    local unnormalizedRatios = 0

    for i = 1, #ratioConfig do 
        local categoryConfig = ratioConfig[i]
        
        if unitsInfo[categoryConfig.categoryName] == nil then unitsInfo[categoryConfig.categoryName] = {} end
        local unitsNB = #unitsInfo[categoryConfig.categoryName]

        units = units + unitsNB
        unitsByCategory[i] = unitsNB

        unnormalizedRatios = unnormalizedRatios + categoryConfig.ratio 
    end

    if units == 0 then units = 1 end

    local maxRatioDiff = 0
    local maxRatioDiffIndex = 0

    for i = 1, #ratioConfig do
        local categoryConfig = ratioConfig[i]

        local desiredRatio = categoryConfig.ratio / unnormalizedRatios
        local currentRatio = unitsByCategory[i] / units

        local ratioDifference = desiredRatio - currentRatio

        if ratioDifference >= maxRatioDiff then
            maxRatioDiff = ratioDifference
            maxRatioDiffIndex = i
        end
        
    end

    return ratioConfig[maxRatioDiffIndex]
end