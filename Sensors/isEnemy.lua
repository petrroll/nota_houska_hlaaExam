local sensorInfo = {
    name = "isEnemy",
    desc = "Returns whether unit is enemy",
    author = "Petrroll",
    date = "2018-07-29",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

local SpringGetUnitAllyTeam = Spring.GetUnitAllyTeam
local SpringGetTeamInfo = Spring.GetTeamInfo
local SpringGetMyTeamID = Spring.GetMyTeamID

local teamID = SpringGetMyTeamID()
local teamID, leader, isDead, isAiTeam, side, allyTeam, customTeamKeys, incomeMultiplier = SpringGetTeamInfo(teamID)

-- @description returns whether unit is enemy
return function(uid)
    return allyTeam ~= SpringGetUnitAllyTeam(uid)
end