-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

function getInfo()
    return {
        onNoUnits = SUCCESS, -- instant success
        tooltip = "Buy unit in param",
        parameterDefs = {
            { 
                name = "uid",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "<uid>",
            },
        }
    }
end
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
function Run(self, units, parameter)

    local uid = parameter.uid
    SpringGiveOrderToUnit(uid, CMD.SELFD, {}, {})

    return SUCCESS
end


function Reset(self)
    return self
end