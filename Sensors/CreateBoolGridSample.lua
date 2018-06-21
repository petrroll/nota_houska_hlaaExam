local sensorInfo = {
    name = "GetBoolGrid for navGraph generation, sample",
    desc = "Sample sensor that creates boolGrid for navmesh generation.",
    author = "Petrroll",
    date = "2018-06-21",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

mapSizeX = Game.mapSizeX
mapSizeZ = Game.mapSizeZ

SpringGetGroundHeight = Spring.GetGroundHeight


local function isLocationGood(location, enemyPos)
    return true
end

-- @description gets a grid representing safe / dangerous positions for flying on map.
return function(gridGranularity)
    local grid = {}
    local goodLocs = {}

    xi = 1 -- x:index to grid
    for x=0, mapSizeX, gridGranularity do
        grid[xi] = {}
        
        yi = 1 -- y:index to grid
        for y=0, mapSizeZ, gridGranularity do

            local location = Vec3(x, SpringGetGroundHeight(x,y), y) 
            local isLocGood = isLocationGood(location)

            grid[xi][yi] = { safe=isLocGood, loc=location }
            if isLocGood then goodLocs[#goodLocs + 1] = location else

            yi = yi + 1
        end
        
        xi = xi + 1
    end
    
    return {grid=grid, trueList=goodLocs, granularity=gridGranularity}
end
