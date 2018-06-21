local sensorInfo = {
	name = "GetPathFromNavGraph",
	desc = "Return a path given a predecessor based navgraph.",
	author = "Petrroll",
	date = "2018-06-21",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end


-- @description returns map of locations specifying a path in a given grid graph
return function(startPosInGrid, destPosInGrid, navGraph)
    local graphGrid = boolGridObj.grid   

    local start = {x=startXi, y=startYi}
    local dest = {x=destXi, y=destYi}


    -- find path in the navgraph trough going from start via .pred references
    if navGraph[startPosInGrid.x] == nil or navGraph[startPosInGrid.x][startPosInGrid.y] == nil then
        return {suc=false, dta=nil}
    end

    local currLoc = startPosInGrid
    local path = {graphGrid[currLoc.x][currLoc.y].loc}
    while currLoc.x ~= destPosInGrid.x or destPosInGrid.y ~= dest.y do
        currLoc = navGraph[currLoc.x][currLoc.y].pred
        path[#path+1] = graphGrid[currLoc.x][currLoc.y].loc
    end

    return {suc=true, dta=path}
end