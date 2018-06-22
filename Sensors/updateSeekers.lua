local sensorInfo = {
	name = "updateSeekers",
	desc = "Updates TRANSPORTS info",
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


local SpringGetUnitDefID = Spring.GetUnitDefID

-- @description return table of all transportable allied units
return function()

	if bb.seekers == nil then bb.seekers = {} end
	local myUnits = bb.unitsInfo.my
	
	seekers = {}
	indexToUid = {}
	uidToIndex = {}

	local index = 1
	for i=1, #myUnits do
		local uid = myUnits[i]
		local defID = SpringGetUnitDefID(uid)

		if(defID ~= nil) then
			if UnitDefs[defID].humanName == "Seer" then

				indexToUid[index] = uid
				uidToIndex[uid] = index

				-- farck is still alive, copy previous state else is new
				if bb.seekers[uid] ~= nil then 
					seekers[uid] = bb.seekers.state[uid] 
				else 
					seekers[uid] = 0
				end

				index = index + 1
	
			end
	
		end

	end

	bb.seekers = {state=seekers, indexToUid = indexToUid, uidToIndex = uidToIndex}
	return {}
end