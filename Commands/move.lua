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
            {
                name = "runningRatio",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "0.25",
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
    local runningRatio = parameter.runningRatio or 0.25


    local cmd = CMD.MOVE
    if parameter.moveViaAttack == true then cmd = CMD.FIGHT end

    if self.commandsIssued == nil then
        self.commandsIssued = {}
    end

    if #unitsGroup == 0 then
        return SUCCESS
    end

    

    -- issue orders
    local issuedNewCommand = false
    for i = 1, #unitsGroup do
        local uid = unitsGroup[i]

        if self.commandsIssued[uid] ~= true then 

            local currUidLoc = Vec3(SpringGetUnitPosition(uid))
            if currUidLoc ~= nil and dest ~= nil and currUidLoc:Distance(dest) > destThreshold then
                local spreadX = math.random(spread) - spread / 2
                local spreadZ = math.random(spread) - spread / 2
    
                SpringGiveOrderToUnit(uid, cmd, (dest + Vec3(spreadX, 0, spreadZ)):AsSpringVector(), {})    
                issuedNewCommand = true
            end

            self.commandsIssued[uid] = true    
        
        end
    end
        
    if issuedNewCommand then
        return RUNNING
    end
    

    -- if some unit not near (spreadwise) destination -> running
    local runningNb = 0
	for i=1, #unitsGroup do
		local uid = unitsGroup[i]
        local currUidLoc = Vec3(SpringGetUnitPosition(uid))
        
		if currUidLoc ~= nil and dest ~= nil and currUidLoc:Distance(dest) > destThreshold then
			if SpringGetUnitHealth(uid) ~= nil then
				runningNb = runningNb + 1
			end
		end
	
    end
    
    if runningNb / #unitsGroup > runningRatio then 
        return RUNNING
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