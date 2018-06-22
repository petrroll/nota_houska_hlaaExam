local sensorInfo = {
	name = "getFreeTransport",
	desc = "Returns a transport that is not busy",
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


return function()

	for key,value in pairs(bb.transports) do

		if value == "free" then
			bb.transports[key] = "busy"
			return key
		end
		
	end

	return nil
end