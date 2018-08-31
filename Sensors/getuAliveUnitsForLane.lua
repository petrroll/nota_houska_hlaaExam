local sensorInfo = {
	name = "getuAliveUnitsForLane",
	desc = "Gets alive units assigned to a lane",
	author = "Petrroll",
	date = "2018-06-29",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

local SensorsIsUnitAlive = Sensors.IsUnitAlive
return function(laneInfoUnits)
	local aliveUnits = {}
	for key,value in pairs(laneInfoUnits) do

		local oneTypePrev = laneInfoUnits[key]
		local oneTypeAlive = {}
		
		local aliveIndex = 1
		for i = 1, #oneTypePrev do
			if SensorsIsUnitAlive(oneTypePrev[i]) then 
				oneTypeAlive[aliveIndex] = oneTypePrev[i]
				aliveIndex = aliveIndex + 1 
			end
		end

		aliveUnits[key] = oneTypeAlive

	end

	return aliveUnits
end

