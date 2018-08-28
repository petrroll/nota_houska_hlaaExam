function getInfo()
    return {
        onNoUnits = SUCCESS, -- instant success
        tooltip = "Gives attack order to units",
        parameterDefs = {
            {
                name = "unitsGroup",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "",
            }, 
            {
                name = "target",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "",
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
local SpringGetUnitCommands = Spring.GetUnitCommands
local SpringGetUnitHealth = Spring.GetUnitHealth
function Run(self, units, parameter)

    local unitsGroup = parameter.unitsGroup
    local target = parameter.target
    local runningRatio = parameter.runningRatio or 0.25

    local cmd = CMD.ATTACK

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
            SpringGiveOrderToUnit(uid, cmd, {}, {})
            self.commandsIssued[uid] = true
            issuedNewCommand = true
        end

    end
        
    if issuedNewCommand then
        return RUNNING
    end
    

    -- if some unit not near (spreadwise) destination -> running
    local runningNb = 0
	for i=1, #unitsGroup do
		local uid = unitsGroup[i]
        local cmds = SpringGetUnitCommands(uid, 0)
        if cmds ~= nil and cmds > 0 then
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