local sensorInfo = {
	name = "getDestLocForLane",
	desc = "Returns destination on lane for unit",
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


return function(uid, lane)
	return Vec3(100, 100, 100) -- TODO: Do calculation 
end