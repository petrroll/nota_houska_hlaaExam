function getInfo()
    return {
        onNoUnits = SUCCESS, -- instant success
        tooltip = "Gives move order to units",
        parameterDefs = {
            {
                name = "unitsGroup",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "",
            }, 
            {
                name = "destination",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "",
            }, 
            {
                name = "spread",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "128",
            }
        }
    }
end

local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitPosition = Spring.GetUnitPosition
local SpringGetUnitHealth = Spring.GetUnitHealth

function Run(self, units, parameter)

    local unitsGroup = parameter.unitsGroup
    local dest = parameter.destination
    local spread = parameter.spread

    -- issue orders

    if not self.commandsIssued then
        for i = 1, #unitsGroup do
            local uid = unitsGroup[i]

            local spreadX = math.random(spread) - spread / 2
            local spreadZ = math.random(spread) - spread / 2

            SpringGiveOrderToUnit(uid, CMD.MOVE, (dest + Vec3(spreadX, 0, spreadZ)):AsSpringVector(), {})
        end
        self.commandsIssued = true
        return RUNNING
    end

    -- if some unit not near (spreadwise) destination -> running
	for i=1, #unitsGroup do
		local uid = unitsGroup[i]
		local pointX, pointY, pointZ = SpringGetUnitPosition(uid)
		local currUidLoc = Vec3(pointX, pointY, pointZ)

		if currUidLoc:Distance(dest) > (spread * 4) then
			if SpringGetUnitHealth(uid) ~= nil then
				return RUNNING
			end
		end
	
	end

    -- else success
    return SUCCESS
end

function New()
    return {commandsIssued=false}
end

function Reset(self)
    self.commandsIssued = false
end