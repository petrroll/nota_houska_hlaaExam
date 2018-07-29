local sensorInfo = {
    name = "getTeamMetal",
    desc = "Returns team's metal",
    author = "Petrroll",
    date = "2018-07-28",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

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
    return SpringGetTeamResources(teamID, "metal")
end