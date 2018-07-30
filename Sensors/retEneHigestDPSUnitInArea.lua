local sensorInfo = {
    name = "retEneHigestDPSUnitInArea",
    desc = "Returns enemy unit with highest DPS in a given area",
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

local SpringGetUnitsInSphere = Spring.GetUnitsInSphere
local retUnitDPS = Sensors.retUnitDPS
local isEnemy = Sensors.isEnemy

-- @description returns enemy unit with highest DPS in a given area
return function(position, radius)

    local unitsInSphere = SpringGetUnitsInSphere(position.x, position.y, position.z, radius)
    
    local maxDPS = 0
    local maxDPSUID = nil
    for i = 1, #unitsInSphere do
        local uid = unitsInSphere[i]
        local uDPS = retUnitDPS(uid)

        if isEnemy(uid) and uDPS > maxDPS then 
            maxDPS = uDPS
            maxDPSUID = uid
        end

    end

    return maxDPSUID
end