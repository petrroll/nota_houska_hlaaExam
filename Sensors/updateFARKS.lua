local sensorInfo = {
	name = "updateFARKS",
	desc = "Updates FARKS info",
	author = "Petrroll",
	date = "2018-06-22",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function initFarksInfo()
	local nfo = {}

	nfo.indexToUid = {}
	nfo.uidToIndex = {}
	nfo.laneAss = {}

	return nfo
end

local SpringGetUnitDefID = Spring.GetUnitDefID
return function()
	if bb.farcks == nil then bb.farcks = initFarksInfo() end

	local myUnits = bb.unitsInfo.my
	local nfo = initFarksInfo()

	local index = 1
	for i = 1, #myUnits do

		local uid = myUnits[i]
		local defID = SpringGetUnitDefID(uid)
		if UnitDefs[defID].humanName == "FARCK" then
			nfo.uidToIndex[uid] = index
			nfo.indexToUid[index] = uid
			index = index + 1
		
			-- farck is still alive, copy previous state else is new
			if bb.farcks.uidToIndex[uid] ~= nil then 
				nfo.laneAss[uid] = bb.farcks.laneAss[uid] 
			else 
				nfo.laneAss[uid] = 0 
			end
		end

	end

	bb.farcks = nfo

	return {}
end