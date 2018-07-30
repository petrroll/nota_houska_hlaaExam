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
            },
            {
                name = "moveViaAttack",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "true",
            },
            {
                name = "destThreshold",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "false",
            },
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
    local destThreshold = parameter.destThreshold or (spread * 3)

    local cmd = CMD.MOVE
    if parameter.moveViaAttack == true then cmd = CMD.FIGHT end

    -- issue orders

    local issuedNewCommand = false
    for i = 1, #unitsGroup do
        local uid = unitsGroup[i]
        if self.commandsIssued[uid] ~= true then 
            local spreadX = math.random(spread) - spread / 2
            local spreadZ = math.random(spread) - spread / 2

            SpringGiveOrderToUnit(uid, cmd, (dest + Vec3(spreadX, 0, spreadZ)):AsSpringVector(), {})
            self.commandsIssued[uid] = true
            issuedNewCommand = true
        end
    end
        
    if issuedNewCommand then
        return RUNNING
    end
    

    -- if some unit not near (spreadwise) destination -> running
	for i=1, #unitsGroup do
		local uid = unitsGroup[i]
		local pointX, pointY, pointZ = SpringGetUnitPosition(uid)
		local currUidLoc = Vec3(pointX, pointY, pointZ)

		if currUidLoc:Distance(dest) > destThreshold then
			if SpringGetUnitHealth(uid) ~= nil then
				return RUNNING
			end
		end
	
	end

    -- else success
    return SUCCESS
end

function New()
    return {commandsIssued={}}
end

function Reset(self)
    self.commandsIssued = {}
end