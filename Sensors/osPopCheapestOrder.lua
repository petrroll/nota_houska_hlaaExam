local sensorInfo = {
    name = "osPopCheapestOrder",
    desc = "Pops affordable order with lowest score (severenity * price)",
    author = "Petrroll",
    date = "2018-07-28",
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

-- @description pops affordable order with lowest score (severenity * price)
return function(orders, prices)

    local minOrder = nil 
    local minOrderKey = nil
    local minOrderScore = 2147483647


    for key, order in pairs(orders) do

        local orderScore = order.severenity * prices[order.name]
        if orderScore < minOrderScore and orderScore < getTeamMetal() then
            minOrderScore = orderScore
            minOrderKey = key
            minOrder = order
        end

    end

    if minOrder ~= nil then
        orders[minOrderKey] = nil
    end

    return minOrder
end