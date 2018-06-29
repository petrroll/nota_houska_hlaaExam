local giveOrderToUnit = Spring.GiveOrderToUnit

function getInfo()
	return {
		onNoUnits = SUCCESS,
		parameterDefs = {
					{ 
				name = "unit",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",

			},
			{ 
				name = "place",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            },
            { 
				name = "radius",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "500",
			},
            { 
				name = "cmd",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "CMD.HEAL",
			}
		
		}

	}
end

local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitCommands = Spring.GetUnitCommands

function Run(self, units, parameter)
	local place = parameter.place
    local unit = parameter.unit
	local radius = parameter.radius
	
	local cmdID = parameter.cmd

	if unit == nil then return SUCCESS end
    if place == nil then return SUCCESS end
	
    if self.running[unit] == nil then
        
		self.running[unit] = true
        SpringGiveOrderToUnit(unit, cmdID,{place.x, place.y, place.z, radius}, {})
        
        return RUNNING
	end
    
    local cmdQ = SpringGetUnitCommands(unit)
	if (cmdQ ~= nil and #cmdQ > 0) then
        return RUNNING
    end

    return SUCCESS
end

function Reset(self)
	self.running = {}
end

function New()
    return {running = {}}
end