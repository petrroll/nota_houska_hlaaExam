local sensorInfo = {
    name = "retReclaimableAtLoc",
    desc = "Returns how much reclaimable metal is around a position",
    author = "Petrroll",
    date = "2018-06-29",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

local SpringGetFeaturesInSphere = Spring.GetFeaturesInSphere
local SpringGetFeatureResources = Spring.GetFeatureResources

-- @description return how much reclaimable metal is around a position
return function(pos, radius)
    local features = SpringGetFeaturesInSphere(pos.x, pos.y, pos.z, radius)
    local reclaim = 0

    for i = 1, #features do
        local currRec = SpringGetFeatureResources(features[i])    
        if currRec > 0 then reclaim = reclaim + currRec end
    end
    
    return reclaim
end