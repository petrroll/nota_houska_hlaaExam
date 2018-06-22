local sensorInfo = {
	name = "getAllBoxes",
	desc = "Update informations about units that need transport",
	author = "Petrroll",
	date = "2018-06-20",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

local SpringGetUnitDefID = Spring.GetUnitDefID
-- @description 
return function()
    if bb.forTransport == nil then bb.forTransport = {} end
	local myUnits = bb.unitsInfo.my
	
	forTransport = {}

	local index = 1
	for i=1, #myUnits do
		local uid = myUnits[i]
		local defID = SpringGetUnitDefID(uid)
		if UnitDefs[defID].humanName == "Box-of-Death" then

			-- unit is still alive, copy previous state else is new
			if bb.forTransport[uid] ~= nil then 
				forTransport[uid] = bb.forTransport[uid] 
			else 
                forTransport[uid] = {}
                forTransport[uid].state = "airlift"
                forTransport[uid].dest  = 0
			end

		end
	end

	bb.forTransport = forTransport
	return {}  
end