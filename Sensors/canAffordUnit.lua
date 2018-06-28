local sensorInfo = {
    name = "CanAffordUnit",
    desc = "Checks I can afford unit / multiplication of unit's price",
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

local SpringGetMyTeamID = Spring.GetMyTeamID
local SpringGetTeamResources = Spring.GetTeamResources
local teamID = SpringGetMyTeamID()

-- @description return if I can afford unit / multiplication of unit's price
return function(prices, unitName, priceMult)
    local metal = SpringGetTeamResources(teamID, "metal")
    return prices[unitName] * priceMult < metal
end