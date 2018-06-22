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

	for key,value in pairs(bb.forTransport) do

		if value.state == "airlift" then
			bb.forTransport[key].state = "beingLifted"
			return key
		end
		
	end

	return nil
end