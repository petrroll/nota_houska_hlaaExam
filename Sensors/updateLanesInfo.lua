local sensorInfo = {
	name = "updateLanesInfo",
	desc = "Gets updated information about current situation on lanes.",
	author = "Petrroll",
	date = "2018-06-21",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

SpringGetUnitPosition = Spring.GetUnitPosition

function shallowCopy(map)
	copy = {}
	for i=1, #map do
		copy[i] = map[i]
	end
	return copy
end

-- init lanes info with default values
function initLanesInfo(paths)
	local lanesInfo = {}

	lanesInfo.map = {}
	lanesInfo.front = {}
	lanesInfo.lanePressure = {}
	lanesInfo.strongpoints = {}

	for i = 1,3 do
		-- init lane's map
		lanesInfo.map[i] = {}
		lanesInfo.front[i] = {}
		lanesInfo.lanePressure[i] = {}
		lanesInfo.strongpoints[i] = {}

		local index = 1
		for j=1, #paths[i] do
			lanesInfo.map[i][index] = {}
			lanesInfo.map[i][index].safe = true
			lanesInfo.map[i][index].loc = paths[i][j]
			index = index + 1
		end
	end

	return lanesInfo
end

-- is location far enough from enemies
local LOC_SAFE_RADIUS = 2000
function isLocSafe(point, unitsInfo)
	local enemies = unitsInfo.enemy

	for i=1,#enemies do
		local enemyLoc = SpringGetUnitPosition(enemies[i])

		if enemyLoc ~= nil then
			if (Vec3(enemyLoc):Distance(point) < LOC_SAFE_RADIUS) then
				return false
			end	
		end
	end
	return true
end

-- update lane information 
function updateLaneSafety(lanesInfo, i, unitsInfo)

	local path = lanesInfo.map[i]
	local front = -1

	local myStrenth = 0
	local enemyStrength = 0

	local dangerStarted = false
	for i=1, #path do

		local loc = path[i].loc
		if not dangerStarted and not isLocSafe(loc, unitsInfo) then
			Spring.Echo("DANGER")
			dangerStarted = true
			front = i
		end

		path[i].safe = not dangerStarted
		
	end
end

local LANE_PRESSURE_RADIUS = 1600
function updateLanePressure(lanesInfo, i, notCountedEnemyUnits)
	lanesInfo.lanePressure[i] = 0
	local strongholds = lanesInfo.strongpoints[i]

	for si=1, #strongholds do
		local sLoc = strongholds[si]
		for ei = 1, #notCountedEnemyUnits do 

			--Not seen yet
			local enemyUID = notCountedEnemyUnits[ei]
			if enemyUID > 0 then 
				local enemyLoc = SpringGetUnitPosition(enemyUID)
				if enemyLoc ~= nil then
					Spring.Echo(Vec3(enemyLoc):Distance(sLoc))

					if (Vec3(enemyLoc):Distance(sLoc) < LANE_PRESSURE_RADIUS) then
						lanesInfo.lanePressure[i] = lanesInfo.lanePressure[i] + 1 -- TODO: Do some units weighting 
						notCountedEnemyUnits[ei] = -1
					end	
				end
				
			end 

		end
	end
end

function processPaths(miPaths) 
	local paths = {}
	local strongpoints = {}

	local i = 1
	for _, miPath in pairs(miPaths) do
		paths[i] = {}
		strongpoints[i] = {}
		for j = 1, #miPath.points do 
			paths[i][j] = miPath.points[j].position
			if miPath.points[j].isStrongpoint then strongpoints[i][#strongpoints[i] + 1] = miPath.points[j].position end
		end

		i = i + 1
	end

	return {p= paths, s=strongpoints}
end

-- @description tst
return function(corridors)
	
	if bb.lanesInfo == nil then
		transformedPaths = processPaths(corridors)
		bb.lanesInfo = initLanesInfo(transformedPaths.p) 
		bb.lanesInfo.strongpoints = transformedPaths.s
	end
	local lanesInfo = bb.lanesInfo
    local unitsInfo = bb.unitsInfo

	local notCountedEnemyUnits = shallowCopy(unitsInfo.enemy)

	for i=1,3 do
		updateLaneSafety(lanesInfo, i, unitsInfo)
		updateLanePressure(lanesInfo, i, notCountedEnemyUnits)
	end

	return {}
end