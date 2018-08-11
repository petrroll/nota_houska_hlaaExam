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
        }
    }
end

local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitCommands = Spring.GetUnitCommands
local SpringGetUnitHealth = Spring.GetUnitHealth
function Run(self, units, parameter)

    local unitsGroup = parameter.unitsGroup
    local target = parameter.target

    local cmd = CMD.ATTACK

    if self.commandsIssued == nil then
        self.commandsIssued = {}
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
	for i=1, #unitsGroup do
		local uid = unitsGroup[i]
		if #SpringGetUnitCommands(uid) > 0  then
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