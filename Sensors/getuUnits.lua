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
    for k, order in pairs(orders) do 

        -- order satisfied -> remove it, assign it in laneInfo, and return laneId
        if order.name == unitName then
            orders[k] = nil
            asssignUnitToLaneInfo(uid, order.category, lanesInfo[order.laneID]) 
            return order.laneID
        end

    end

    return 0
end

-- @description updates unit info
return function(unitsInfo, lanesInfo)
    local oldReg = unitsInfo.unitToLine or {}
    local newReg = {}

    local orders = unitsInfo.orders or {}

    local myUnits = Spring.GetTeamUnits(Spring.GetMyTeamID())
    local newUnitsInfo = {}

    -- either copy unit's lane assignment from previous data or register it
    for i=1, #myUnits do 
        local uid = myUnits[i]
        if oldReg[uid] == nil or oldReg[uid] == 0 then newReg[uid] = registerUnit(uid, orders, lanesInfo)
        else newReg[uid] = oldReg[uid] end
    end

    return {unitToLine=newReg, orders = orders}
end