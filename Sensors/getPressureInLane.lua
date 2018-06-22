local sensorInfo = {
	name = "updateLanesInfo",
	desc = "Gets updated information about current situation on lanes.",
	author = "Petrroll",
	date = "2018-06-21",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

SpringGetUnitPosition = Spring.GetUnitPosition

-- @description tst
local myAllyID = Spring.GetMyAllyTeamID()
return function(corridor, pressureRad) 
    local lanePressure = 0
    local lastSafe = 0

    local points = {}

    local points = corridor.points 
    local enemyTeams = Sensors.core.EnemyTeamIDs()
    local delta = 500

    for i = 1, #points do 
        local sLoc = points[i].position
        local inRect = 0

        points[#points + 1] = sLoc

        for i=1, #enemyTeams do
            inRect = inRect + #Spring.GetUnitsInRectangle(sLoc.x - delta, sLoc.z - delta, sLoc.x + delta, sLoc.z + delta, enemyTeams[i])
        end

        if inRect > 0 and lastSafe == 0 then 
            lastSafe = i - 3
        end

        lanePressure = lanePressure + inRect
    end

    if lastSafe < 1 then lastSafe = 5 end
	return {p=lanePressure, fLoc = points[lastSafe].position}
end