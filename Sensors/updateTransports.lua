local sensorInfo = {
	name = "updateTRANSPORTS",
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

	if bb.transports == nil then bb.transports = {} end
	local myUnits = bb.unitsInfo.my
	
	transports = {}

	local index = 1
	for i=1, #myUnits do
		local uid = myUnits[i]
		local defID = SpringGetUnitDefID(uid)
		if UnitDefs[defID].isTransport then

			-- farck is still alive, copy previous state else is new
			if bb.transports[uid] ~= nil then 
				transports[uid] = bb.transports[uid] 
			else 
				transports[uid] = "free"
			end

		end
	end

	bb.transports = transports
	return {}
end