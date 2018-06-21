local sensorInfo = {
	name = "Position",
	desc = "Return position of the unit specified by uid.",
	author = "Petrroll",
	date = "2018-05-31",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

-- speedups
local SpringGetUnitPosition = Spring.GetUnitPosition

-- @description returns a position of one unit / the position of of the first units
return function(uid)
	local selUid = uid or units[1]

	local x,y,z = SpringGetUnitPosition(selUid)
	return Vec3(x,y,z)
end