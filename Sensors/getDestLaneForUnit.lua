local sensorInfo = {
	name = "getDestLaneForUnit",
	desc = "Returns destination lane for unit",
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


return function(uid)
	return 1 -- TODO: Do calculation 
end