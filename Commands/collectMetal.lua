
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
			}
		
		}

	}
end

running = {}
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitCommands = Spring.GetUnitCommands
local radius = 2000


function Run(self, units, parameter)

	local place = parameter.place
	local unit = parameter.unit
	
	if unit == nil then return SUCCESS end
	if place == nil then return SUCCESS end
	
    if running[unit] == nil then
        
        Spring.Echo("ORDER GIVEN")

		running[unit] = true
		local cmdID = CMD.RECLAIM
		x,y,z = place["x"],place["y"],place["z"]
        SpringGiveOrderToUnit(unit, cmdID,{x,y,z,radius},{})
        
        return RUNNING
	end
    
    local cmdQ = SpringGetUnitCommands(unit)
	if (cmdQ ~= nil and #cmdQ > 0) then
        return RUNNING
    end

    return SUCCESS
end

function Reset(self)
	running = {}
end
