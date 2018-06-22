local sensorInfo = {
	name = "UpdateUnitsInfo",
	desc = "Gets updated info about units.",
	author = "Petrroll",
	date = "2018-06-18",
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

-- @description tst
local myAllyID = Spring.GetMyAllyTeamID()
local myId = Spring.GetMyTeamID()

local SpringGetUnitAllyTeam = Spring.GetUnitAllyTeam
local SpringGetUnitTeam = Spring.GetUnitTeam 

return function()
	local myUnits = {}
	local alliedUnits = {}
	local enemyUnits = {}

	local allUnits = Spring.GetAllUnits()
	
	for i=1, #allUnits do 
		local uid = allUnits[i]
		if SpringGetUnitAllyTeam(uid) == myAllyID then
			alliedUnits[#alliedUnits + 1] = uid
			if SpringGetUnitTeam(uid) == myId then myUnits[#myUnits + 1] = uid end
		else 
			enemyUnits[#enemyUnits + 1] = uid
		end
	end

	bb.unitsInfo = {my = myUnits, allied=allied, enemy=enemyUnits} 
end