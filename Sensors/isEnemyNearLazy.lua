local sensorInfo = {
    name = "isEnemyNearLazy",
    desc = "Returns cached information about wheter enemy is near a unit.",
    author = "Petrroll",
    date = "2018-08-27",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end


SpringGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
lazyTable = {}

-- @description returns whether unit is in danger
return function(uid, radius, cacheForTicks)

    local cachedResult = lazyTable[uid]
    if cachedResult ~= nil and cachedResult.since < cacheForTicks then
        cachedResult.since = cachedResult.since + 1
        return cachedResult.result
    end

    local res = (SpringGetUnitNearestEnemy(uid, radius, false) ~= nil)
    lazyTable[uid] = {result = res, since = 0 }

    return res
end