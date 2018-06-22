local sensorInfo = {
	name = "findMetalSpot",
	desc = "Find place on lane, where it is safe and there is metal to be collected",
	author = "Petrroll",
	date = "2018-06-22",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 10
local SpringGetUnitPosition = Spring.GetUnitPosition

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

local radius = 2000 --TODO const

local SpringGetMetalAmount = Spring.GetMetalAmount

function hasMetal(point) 
	local x,z = point["x"],point["z"]
	local X,Z = math.floor(x/16), math.floor(z/16)
    local mRadius = math.floor(radius/16)
    
	local amount = 0
	for dx =-mRadius,mRadius do
		for dz =-mRadius,mRadius do
			amount = amount + SpringGetMetalAmount(X+dx,Z+dz)
		end
    end
    
	return (amount > 0)
end

return function(lane)
    for i = 1, #lane do
        local lanePoint = bb.lanesInfo.map[lane][i]
		if lanePoint.safe and hasMetal(lanePoint.loc) then 
			return lanePoint.loc
		end
	end
	return nil
end