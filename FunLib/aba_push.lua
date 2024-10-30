local Push = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local ShouldNotPushLane = false
local LanePushCooldown = 0
local LanePush = LANE_MID

local GlyphDuration = 7
local ShoulNotPushTower = false
local TowerPushCooldown = 0

local pingTimeDelta = 5

function Push.GetPushDesire(bot, lane)
    if bot.laneToPush == nil then bot.laneToPush = lane end

    local maxDesire = 0.95
    local nModeDesire = bot:GetActiveModeDesire()
    local nInRangeEnemy = bot:GetNearbyHeroes(900, true, BOT_MODE_NONE)

	if nInRangeEnemy ~= nil and #nInRangeEnemy > 0
    or (bot:GetAssignedLane() ~= lane and J.GetPosition(bot) == 1 and DotaTime() < 12 * 60) -- reduce carry feeds
    or (J.IsDoingRoshan(bot) and #J.GetAlliesNearLoc(J.GetCurrentRoshanLocation(), 2800) >= 3)
	then
		return BOT_MODE_DESIRE_NONE
	end

	if J.IsDefending(bot) and nModeDesire > 0.8
    then
        maxDesire = 0.80
    end

    for i = 1, 5
    do
		local member = GetTeamMember(i)
        if member ~= nil and member:GetLevel() < 8 then return BOT_MODE_DESIRE_NONE end
    end

    local human, humanPing = J.GetHumanPing()
	if human ~= nil and DotaTime() > pingTimeDelta
	then
		local isPinged, pingedLane = J.IsPingCloseToValidTower(GetOpposingTeam(), humanPing)
		if isPinged and lane == pingedLane
		and DotaTime() < humanPing.time + pingTimeDelta
		then
			return BOT_ACTION_DESIRE_ABSOLUTE * 0.95
		end
	end

    if ShoulNotPushTower
    then
        if DotaTime() < TowerPushCooldown + GlyphDuration
        then
            return BOT_ACTION_DESIRE_NONE
        else
            ShoulNotPushTower = false
            TowerPushCooldown = 0
        end
    end

    if ShouldNotPushLane
    then
        if DotaTime() < LanePushCooldown + 10
        then
            if LanePush == lane then
                return BOT_MODE_DESIRE_NONE
            end
        else
            ShouldNotPushLane = false
            LanePushCooldown = 0
        end
    end

    local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)
    local allyKills = J.GetNumOfTeamTotalKills(false) + 1
    local enemyKills = J.GetNumOfTeamTotalKills(true) + 1
    local aAliveCoreCount = J.GetAliveCoreCount(false)
    local eAliveCoreCount = J.GetAliveCoreCount(true)
    local nPushDesire = GetPushLaneDesire(lane)

    local botTarget = bot:GetAttackTarget()
    if J.IsValidBuilding(botTarget)
    then
        if  botTarget:HasModifier('modifier_fountain_glyph')
        and not (aAliveCount >= eAliveCount + 2)
        then
            ShoulNotPushTower = true
            TowerPushCooldown = DotaTime()
            return BOT_ACTION_DESIRE_NONE
        end

        if botTarget:HasModifier('modifier_backdoor_protection')
        or botTarget:HasModifier('modifier_backdoor_protection_in_base')
        or botTarget:HasModifier('modifier_backdoor_protection_active')
        then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    if bot:WasRecentlyDamagedByTower(3)
    or J.GetHP(bot) < 0.45
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local enemyCountInLane = J.GetEnemyCountInLane(lane)
    if enemyCountInLane > 0
    then
        local nInRangeAlly = J.GetAlliesNearLoc(GetLaneFrontLocation(GetTeam(), lane, 0), 1600)

        if enemyCountInLane > #nInRangeAlly
        then
            ShouldNotPushLane = true
            LanePushCooldown = DotaTime()
            LanePush = lane
            return BOT_MODE_DESIRE_NONE
        end
    end

    local vEnemyLaneFrontLocation = GetLaneFrontLocation(GetOpposingTeam(), lane, 0)
    local hTeleports = GetIncomingTeleports()
    local nTPCount = 0
    for _, tp in pairs(hTeleports) do
        if tp ~= nil
        and J.GetDistance(vEnemyLaneFrontLocation, tp.location) <= 1600
        and Push.IsEnemyTP(tp.playerid)
        then
            nTPCount = nTPCount + 1
        end
    end

    if nTPCount > 0 then
        local nInRangeAlly__ = J.GetAlliesNearLoc(vEnemyLaneFrontLocation, 1600)
        local nInRangeEnemy__ = J.GetEnemiesNearLoc(vEnemyLaneFrontLocation, 1600)
        if (#nInRangeAlly__ < #nInRangeEnemy__ + nTPCount)
        then
            ShouldNotPushLane = true
            LanePushCooldown = DotaTime()
            LanePush = lane
            return BOT_MODE_DESIRE_NONE
        end
    end

    -- General Push
    if (not J.IsCore(bot) and (Push.WhichLaneToPush(bot) == lane))
    or (J.IsCore(bot) and ((J.IsLateGame() and (Push.WhichLaneToPush(bot) == lane)) or (J.IsEarlyGame() or J.IsMidGame())))
    then
        if eAliveCount == 0
        or aAliveCoreCount >= eAliveCoreCount
        or (aAliveCoreCount >= 1 and aAliveCount >= eAliveCount + 2)
        then
            if J.DoesTeamHaveAegis()
            then
                local aegis = 1.3
                nPushDesire = nPushDesire * aegis
            end

            if aAliveCount >= eAliveCount
            and J.GetAverageLevel(GetTeam()) >= 12
            then
                -- nPushDesire = nPushDesire * RemapValClamped(allyKills / enemyKills, 1, 2, 1, 2)
                nPushDesire = nPushDesire + RemapValClamped(allyKills / enemyKills, 1, 2, 0.0, 1)
            end

            bot.laneToPush = lane
            return Clamp(nPushDesire, 0, maxDesire)
        end
    end

    return BOT_MODE_DESIRE_NONE
end

local TeamLocation = {}
function Push.WhichLaneToPush(bot)
    for i = 1, 5 do
        local member = GetTeamMember(i)
        if member ~= nil and member:IsAlive() then
            TeamLocation[member:GetPlayerID()] = member:GetLocation()
        end
    end

    local distanceToTop = 0
    local distanceToMid = 0
    local distanceToBot = 0

    for i, id in pairs(GetTeamPlayers(GetTeam()))
    do
        if TeamLocation[id] ~= nil and i <= 3
        then
            if IsHeroAlive(id)
            then
                distanceToTop = math.max(distanceToTop, J.GetDistance(GetLaneFrontLocation(GetTeam(),LANE_TOP, 0), TeamLocation[id]))
                distanceToMid = math.max(distanceToMid, J.GetDistance(GetLaneFrontLocation(GetTeam(),LANE_MID, 0), TeamLocation[id]))
                distanceToBot = math.max(distanceToBot, J.GetDistance(GetLaneFrontLocation(GetTeam(),LANE_BOT, 0), TeamLocation[id]))
            end
        end
    end

    if  distanceToTop < distanceToMid
    and distanceToTop < distanceToBot
    then
        return LANE_TOP
    end

    if  distanceToMid < distanceToTop
    and distanceToMid < distanceToBot
    then
        return LANE_MID
    end

    if  distanceToBot < distanceToTop
    and distanceToBot < distanceToMid
    then
        return LANE_BOT
    end

    return nil
end

function Push.TeamPushLane()

    local team = TEAM_RADIANT

    if GetTeam() == TEAM_RADIANT then
        team = TEAM_DIRE
    end
  
    if GetTower(team, TOWER_MID_1) ~= nil then
        return LANE_MID;
    end
    if GetTower(team, TOWER_BOT_1) ~= nil then
        return LANE_BOT;
    end
    if GetTower(team, TOWER_TOP_1) ~= nil then
        return LANE_TOP;
    end
  
    if GetTower(team, TOWER_MID_2) ~= nil then
        return LANE_MID;
    end
    if GetTower(team, TOWER_BOT_2) ~= nil then
        return LANE_BOT;
    end
    if GetTower(team, TOWER_TOP_2) ~= nil then
        return LANE_TOP;
    end
  
    if GetTower(team, TOWER_MID_3) ~= nil
    or GetBarracks(team, BARRACKS_MID_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_MID_RANGED) ~= nil then
        return LANE_MID;
    end

    if GetTower(team, TOWER_BOT_3) ~= nil 
    or GetBarracks(team, BARRACKS_BOT_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_BOT_RANGED) ~= nil then
        return LANE_BOT;
    end

    if GetTower(team, TOWER_TOP_3) ~= nil
    or GetBarracks(team, BARRACKS_TOP_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_TOP_RANGED) ~= nil then
        return LANE_TOP;
    end

    return LANE_MID
end

function Push.PushThink(bot, lane)
    if J.CanNotUseAction(bot) then return end

    local botAttackRange = bot:GetAttackRange()
    local fDeltaFromFront = (Min(J.GetHP(bot), 0.7) * 1000 - 700) + RemapValClamped(botAttackRange, 300, 700, 0, -600)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)
    local targetLoc = GetLaneFrontLocation(GetTeam(), lane, fDeltaFromFront)

    local nEnemyAncient = GetAncient(GetOpposingTeam())
    if  GetUnitToUnitDistance(bot, nEnemyAncient) < 1600
    and J.CanBeAttacked(nEnemyAncient)
    then
        bot:Action_AttackUnit(nEnemyAncient, true)
        return
    end

    local nCreeps = bot:GetNearbyLaneCreeps(math.min(700 + botAttackRange, 1600), true)
    if  nCreeps ~= nil and #nCreeps > 0
    and J.CanBeAttacked(nCreeps[1])
    then
        bot:Action_AttackUnit(nCreeps[1], true)
        return
    end

    local nBarracks = bot:GetNearbyBarracks(math.min(700 + botAttackRange, 1600), true)
    if  nBarracks ~= nil and #nBarracks > 0
    and Push.CanBeAttacked(nBarracks[1])
    then
        bot:Action_AttackUnit(nBarracks[1], true)
        return
    end

    if  nEnemyTowers ~= nil and #nEnemyTowers > 0
    and Push.CanBeAttacked(nEnemyTowers[1])
    then
        bot:Action_AttackUnit(nEnemyTowers[1], true)
        return
    end

    local sEnemyTowers = bot:GetNearbyFillers(math.min(700 + botAttackRange, 1600), true)
    if  sEnemyTowers ~= nil and #sEnemyTowers > 0
    and Push.CanBeAttacked(sEnemyTowers[1])
    then
        bot:Action_AttackUnit(sEnemyTowers[1], true)
        return
    end

    bot:Action_MoveToLocation(targetLoc)
end

function Push.CanBeAttacked(building)
    if  building ~= nil
    and building:CanBeSeen()
    and not building:IsInvulnerable()
    then
        return true
    end

    return false
end

function Push.IsEnemyTP(nID)
    for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
        if id == nID then
            return true
        end
    end

    return false
end

return Push