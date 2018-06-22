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

	for i = 1,3 do
		-- init lane's map
		lanesInfo.map[i] = {}
		lanesInfo.front[i] = {}
		lanesInfo.lanePressure[i] = {}

		local index = 1
		for j=1, #paths[i] do
			lanesInfo.map[i][index].safe = true
			lanesInfo.map[i][index].loc = paths[i][j]
			index = index + 1
		end
	end
end

-- is location far enough from enemies
local LOC_SAFE_RADIUS = 2000
function isLocSafe(point, unitsInfo)
	local enemies = unitsInfo.enemy

	for i=1,#enemies do
		if (Vec3(SpringGetUnitPosition(enemies[i])):Distance(point) < LOC_SAFE_RADIUS) then
			return false
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
		if not dangerStarted and not isLocSafe(key, unitsInfo) then
			dangerStarted = true
			front = i
		end

		path[i].safe = dangerStarted
		
	end
end

local LANE_PRESSURE_RADIUS = 5000
function updateLanePressure(lanesInfo, i, strongholds, notCountedEnemyUnits)
	lanesInfo.lanePressure[i] = 0

	for si=1, #strongholds[si] do
		local sLoc = strongholds[i][si]
		for ei = 1, #notCountedEnemyUnits do 

			--Not seen yet
			local enemyUID = notCountedEnemyUnits[ei]
			if enemyUID > 0 then 
				
				if (Vec3(SpringGetUnitPosition(enemyUID)):Distance(sLoc) < LANE_PRESSURE_RADIUS) then
					lanesInfo.lanePressure[i] = lanesInfo.lanePressure[i] + 1 -- TODO: Do some units weighting 
					notCountedEnemyUnits[ei] = -1
				end
				
			end 

		end
	end
end

-- @description tst
return function(paths, strongholds)
	
	if bb.lanesInfo == nil then bb.lanesInfo = initLanesInfo(paths) end
	local lanesInfo = bb.lanesInfo
    local unitsInfo = bb.unitsInfo

	local notCountedEnemyUnits = shallowCopy(unitsInfo.enemy)

	for i=1,3 do
		updateLaneSafety(lanesInfo, i, unitsInfo)
		updateLanePressure(lanesInfo, i, strongholds, notCountedEnemyUnits)
	end

	return {}
end