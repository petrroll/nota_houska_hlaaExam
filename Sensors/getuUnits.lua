local sensorInfo = {
	name = "getuUnits",
	desc = "Gets updated info about units.",
	author = "Petrroll",
	date = "2018-06-18",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


-- assign a unit to corresponding lane.units table 
function asssignUnitToLaneInfo(uid, category, laneInfo) 
    local lanesUnits = laneInfo.units 
    lanesUnits[category] = lanesUnits[category] or {}

    currTypeOfUnitsInLane = lanesUnits[category]
    currTypeOfUnitsInLane[#currTypeOfUnitsInLane + 1] = uid
end

-- finds lane that ordered this new unit -> returns laneID
local SpringGetUnitDefID = Spring.GetUnitDefID
function registerUnit(uid, orders, lanesInfo)

    local unitName = UnitDefs[SpringGetUnitDefID(uid)].name
    local minMatchingSeverenity = 2147483647
    local minMatchingOrderId = 0

    -- select matching order with lowest severenity
    for k, order in pairs(orders) do 
        if order.name == unitName and order.severenity < minMatchingSeverenity then
            minMatchingSeverenity = order.severenity
            minMatchingOrderId = k
        end
    end

    -- order satisfied -> remove it, assign it in laneInfo, and return laneId
    if minMatchingOrderId ~= 0 then
        local order = orders[minMatchingOrderId]
        orders[minMatchingOrderId] = nil

        asssignUnitToLaneInfo(uid, order.category, lanesInfo[order.laneID]) 
        return order.laneID

    end

    return 0
end

-- @description updates unit info
MyTeamId = Spring.GetMyTeamID()
SpringGetTeamUnits = Spring.GetTeamUnits 
return function(unitsInfo, lanesInfo)
    local oldReg = unitsInfo.unitToLine or {}
    local newReg = {}

    local orders = unitsInfo.orders or {}

    local myUnits = SpringGetTeamUnits(MyTeamId)
    local newUnitsInfo = {}

    -- either copy unit's lane assignment from previous data or register it
    for i=1, #myUnits do 
        local uid = myUnits[i]
        if oldReg[uid] == nil or oldReg[uid] == 0 then newReg[uid] = registerUnit(uid, orders, lanesInfo)
        else newReg[uid] = oldReg[uid] end
    end

    return {unitToLine=newReg, orders = orders}
end