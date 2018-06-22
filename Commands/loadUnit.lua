function getInfo()
	return {
		onNoUnits = RUNNING, -- instant success
		tooltip = "Loads a unit to a transporter.",
		parameterDefs = {
			{ 
				name = "transporter",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "unit", 
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            },
		}
	}
end


-- speed-ups
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitCommands = Spring.GetUnitCommands
local SpringGetUnitIsTransporting = Spring.GetUnitIsTransporting

function Run(self, units, parameter)
    local target_unit = parameter.unit
    local transport = parameter.transporter

	local isTransporting = (SpringGetUnitIsTransporting(transport) ~= nil)
	if isTransporting then return SUCCESS end

	if #SpringGetUnitCommands(transport) > 0 then
        return RUNNING
    end

	if isTransporting == false then
        SpringGiveOrderToUnit(transport, CMD.LOAD_UNITS, { target_unit }, CMD.OPT_SHIFT)
        return RUNNING
    end

    return SUCCESS
end

function Reset(self)
end
