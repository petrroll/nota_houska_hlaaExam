-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

local next = next 

function getInfo()
    return {
        onNoUnits = RUNNING, 
        tooltip = "Buy unit in param",
        parameterDefs = {
            { 
                name = "orders",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "bb.units.orders",
            },
            { 
                name = "buyInfo",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "bb.missionInfo.buy",
            },
        }
    }
end

local SpringGetMyTeamID = Spring.GetMyTeamID
local SpringGetTeamResources = Spring.GetTeamResources
local teamID = SpringGetMyTeamID()

local SpringGetMyTeamID = Spring.GetMyTeamID
local SpringGetTeamResources = Spring.GetTeamResources
local teamID = SpringGetMyTeamID()


-- @description pops affordable order with lowest score (severenity * price)
function osPopCheapestOrder(orders, prices)

    local minOrder = nil 
    local minOrderKey = nil
    local minOrderScore = 2147483647
    local teamMetal = SpringGetTeamResources(teamID, "metal")

    for key, order in pairs(orders) do

        local orderPrice = prices[order.name]
        local orderScore = order.severenity * orderPrice
        if orderScore < minOrderScore and orderPrice < teamMetal  then
            minOrderScore = orderScore
            minOrderKey = key
            minOrder = order
        end

    end

    if minOrder ~= nil then
        orders[minOrderKey] = nil
    end

    return minOrder
end

function Run(self, units, parameter)

    local orders = parameter.orders
    local buyInfo = parameter.buyInfo

    local order = osPopCheapestOrder(orders, buyInfo)
    if order ~= nil then 
        message.SendRules({
            subject = "swampdota_buyUnit",
            data = {
                unitName = order.name
            },
        })
    end

    return SUCCESS
end


function Reset(self)
    return self
end