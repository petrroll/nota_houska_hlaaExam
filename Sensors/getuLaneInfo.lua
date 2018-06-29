local sensorInfo = {
	name = "getuLaneInfo",
	desc = "Gets updated information about current situation on a lane.",
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


local SpringGetUnitsInRectangle = Spring.GetUnitsInRectangle
local EnemyTeams = Sensors.core.EnemyTeamIDs()
local DELTA = 400

-- @description gets updated information about lane situation
local myAllyID = Spring.GetMyAllyTeamID()
return function(corridor, lastLaneInfo) 
    local enemyTeams = Sensors.core.EnemyTeamIDs()

    local pressure = 0
    local frontPosIndex = 0

    local points = {}
    local miPoints = corridor.points

    for i = 1, #miPoints do 

        local pos = miPoints[i].position
        local enemInRect = 0

        -- add position to current lane's points 
        points[#points + 1] = pos

        -- add enemies from all enemy teams that are around given position
        for j=1, #EnemyTeams do
            enemInRect = enemInRect + #SpringGetUnitsInRectangle(pos.x - DELTA, pos.z - DELTA, pos.x + DELTA, pos.z + DELTA, EnemyTeams[j])
        end

        -- update pressure & index of last safe position
        pressure = pressure + enemInRect
        if enemInRect > 0 and frontPosIndex == 0 then frontPosIndex = i end

    end

    -- if no front visible -> use previous one / 5 as default
    if frontPosIndex == 0 then
        if lastLaneInfo == nil or lastLaneInfo.frontPosIndex == nil then frontPosIndex = 5
        else frontPosIndex = lastLaneInfo.frontPosIndex end
    end

	return {pressure=pressure, frontPosIndex = frontPosIndex, points = points}
end