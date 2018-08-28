-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

function getInfo()
    return {
        onNoUnits = RUNNING,
        tooltip = "Buy unit in param",
        parameterDefs = {
            { 
                name = "unitName",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "'armbox'",
            },
            { 
                name = "laneID",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "1",
            },
            { 
                name = "severenity",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "1",
            },
            { 
                name = "categoryInLane",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "'armbox'",
            },
            { 
                name = "orders",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "<ordersMap>",
            },
        }
    }
end





function Run(self, units, parameter)

    local unitName = parameter.unitName 
    local laneID = parameter.laneID 
    local severenity = parameter.severenity 
    local categoryInLane = parameter.categoryInLane 
    local orders = parameter.orders 

    for _, order in pairs(orders) do
        if (order.name == unitName and order.laneID == laneID and order.severenity == severenity and order.category == categoryInLane) then           
            return FAILURE   
        end
    end

    orders[#orders + 1] = {name=unitName, laneID = laneID, severenity = severenity, category = categoryInLane}
    return SUCCESS
end


function Reset(self)
    return self
end