function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Loads all units to transporter.",
		parameterDefs = {
			{ 
				name = "transporter",
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
                name = "radius",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "150",
            }
		}
	}
end

-- speed-ups
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitCommands = Spring.GetUnitCommands
local SpringGetUnitIsTransporting = Spring.GetUnitIsTransporting

function Run(self, units, parameter)
    local target = parameter.target
    local radius = parameter.radius
    local transport = parameter.transporter

	local isTransporting = (SpringGetUnitIsTransporting(transport) ~= nil and #SpringGetUnitIsTransporting(transport) > 0)
    if isTransporting == false then return SUCCESS end

	local cmds = SpringGetUnitCommands(transport, 0)
	if cmds ~= nil and cmds > 0 then
	return RUNNING
    end

    if isTransporting then
        SpringGiveOrderToUnit(transport, CMD.UNLOAD_UNITS, { target.x, target.y, target.z, radius }, CMD.OPT_SHIFT)
        SpringGiveOrderToUnit(transport, CMD.MOVE, target:AsSpringVector(), CMD.OPT_SHIFT)
        return RUNNING
    end

    return SUCCESS
end

function Reset(self)
end
