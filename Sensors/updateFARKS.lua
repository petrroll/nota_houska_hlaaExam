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
	farcks = {}

	farcks.laneAss = {}
	farcks.uids = {}
	farcks.inLine = {}

	for i = 1, 3 do
		farcks.inLine[i] = 0
	end

	return farcks
end

local SpringGetUnitDefID = Spring.GetUnitDefID
return function()
	if bb.farcks == nil then bb.farcks = initFarksInfo() end

	local myUnits = bb.unitsInfo.my

	local farcks = {}
	local farcksUids = {}
    local farcksInLine = {}
	for i = 1, 3 do
		farcksInLine[i] = 0
	end

	for i = 1, #myUnits do

		local uid = myUnits[i]
		local defID = SpringGetUnitDefID(uid)
		if UnitDefs[defID].humanName == "FARCK" then
			-- farck is still alive, copy previous state else is new
			if bb.farcks[uid] ~= nil then 
				farcks[uid] = bb.farcks[uid] 
				farcksInLine[bb.farcks[uid]] = farcksInLine[bb.farcks[uid]] + 1
			else 
				farcks[uid] = 0 
			end
			farcksUids[#farcksUids + 1] = uid
		end

	end

	bb.farcks.laneAss = farcks
	bb.farcks.uids = farcksUids
	bb.farcks.inLine = farcksInLine

	return {}
end