require "VPrediction"
require "SourceLib"
require "SOW"

if myHero.charName ~= "Lissandra" then return end

local version = 1.22
local autoUpdate = true	
local scriptName = "RyukLissandra"
local sourceLibFound = true
if FileExist(LIB_PATH .. "SourceLib.lua") then
    require "SourceLib"
else
    sourceLibFound = false
    DownloadFile("https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua", LIB_PATH .. "SourceLib.lua", function() print("<font color=\"#6699ff\"><b>" .. scriptName .. ":</b></font> <font color=\"#FFFFFF\">SourceLib downloaded! Please reload!</font>") end)
end
if not sourceLibFound then return end

-- Updater
if autoUpdate then
    SourceUpdater(scriptName, version, "raw.github.com", "/RyukOP/Scripts/master/RyukLissandra.lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/RyukOP/Scripts/master/RyukLissandra.version"):SetSilent(silentUpdate):CheckUpdate()
end
-- Tables --

-- Gap Closers
gapCloseList = {
        ['Ahri']        = {true, spell = 'AhriTumble'},
        ['Aatrox']      = {true, spell = 'AatroxQ'},
        ['Akali']       = {true, spell = 'AkaliShadowDance'}, 
        ['Alistar']     = {true, spell = 'Headbutt'}, 
        ['Diana']       = {true, spell = 'DianaTeleport'}, 
        ['Gragas']      = {true, spell = 'GragasE'},
        ['Graves']      = {true, spell = 'GravesMove'},
        ['Hecarim']     = {true, spell = 'HecarimUlt'},
        ['Irelia']      = {true, spell = 'IreliaGatotsu'},
        ['JarvanIV']    = {true, spell = 'JarvanIVDragonStrike'},
        ['Jax']         = {true, spell = 'JaxLeapStrike'}, 
        ['Jayce']       = {true, spell = 'JayceToTheSkies'}, 		
        ['Katarina']	 = {true, spell = 'KatarinaE'},
        ['Khazix']      = {true, spell = 'KhazixW'},
        ['Leblanc']     = {true, spell = 'LeblancSlide'},
        ['LeeSin']      = {true, spell = 'blindmonkqtwo'},
        ['Leona']       = {true, spell = 'LeonaZenithBlade'},
        ['Malphite']    = {true, spell = 'UFSlash'},
        ['Maokai']      = {true, spell = 'MaokaiTrunkLine',}, 		
        ['MasterYi']	 = {true, spell = 'AlphaStrike',}, 	    
        ['MonkeyKing']  = {true, spell = 'MonkeyKingNimbus'},         
	['Pantheon']    = {true, spell = 'PantheonW'}, 		
	['Pantheon']    = {true, spell = 'PantheonRJump'},
        ['Pantheon']    = {true, spell = 'PantheonRFall'},
        ['Poppy']       = {true, spell = 'PoppyHeroicCharge'}, 		
        ['Renekton']    = {true, spell = 'RenektonSliceAndDice'},
        ['Sejuani']     = {true, spell = 'SejuaniArcticAssault'},
        ['Shen']        = {true, spell = 'ShenShadowDash'},
        ['Tristana']    = {true, spell = 'RocketJump'},
        ['Tryndamere']  = {true, spell = 'Slash'},
        ['XinZhao']     = {true, spell = 'XenZhaoSweep'}, 		
}

-- Interrupt List
champsToStun = {
	{ charName = "Katarina",        spellName = "KatarinaR" ,                  important = 0},
    { charName = "Galio",           spellName = "GalioIdolOfDurand" ,          important = 0},
    { charName = "FiddleSticks",    spellName = "Crowstorm" ,                  important = 1},
    { charName = "FiddleSticks",    spellName = "DrainChannel" ,               important = 1},
    { charName = "Nunu",            spellName = "AbsoluteZero" ,               important = 0},
    { charName = "Shen",            spellName = "ShenStandUnited" ,            important = 0},
    { charName = "Urgot",           spellName = "UrgotSwap2" ,                 important = 0},
    { charName = "Malzahar",        spellName = "AlZaharNetherGrasp" ,         important = 0},
    { charName = "Karthus",         spellName = "FallenOne" ,                  important = 0},
    { charName = "Pantheon",        spellName = "PantheonRJump" ,              important = 0},
	{ charName = "Pantheon",        spellName = "PantheonRFall",               important = 0},
    { charName = "Varus",           spellName = "VarusQ" ,                     important = 1},
    { charName = "Caitlyn",         spellName = "CaitlynAceintheHole" ,        important = 1},
    { charName = "MissFortune",     spellName = "MissFortuneBulletTime" ,      important = 1},
    { charName = "Warwick",         spellName = "InfiniteDuress" ,             important = 0},
	{ charName = "MonkeyKing",		  spellName = "MonkeyKingSpinToWin",         important = 0}
}


function OnLoad()
	
	VP = VPrediction()
	qRng, wRng, eRng, rRng = 825, 450, 1050, 550
	Q = Spell(_Q, qRng):SetSkillshot(VP, SKILLSHOT_LINEAR, 75, 0.5, 1200, false)
	W = Spell(_W, wRng)
	E = Spell(_E, eRng):SetSkillshot(VP, SKILLSHOT_LINEAR, 110, 0.5, 850, false)
	R = Spell(_R, rRng)
	DFG = Item(3128,750)
	--DamageLib:RegisterDamageSource(spellId, damagetype, basedamage, perlevel, scalingtype, scalingstat, percentscaling, condition, extra)
	DLib = DamageLib()
	DLib:RegisterDamageSource(_Q, _MAGIC, 75, 35, _MAGIC, _AP, 0.65, function() return (player:CanUseSpell(_Q) == READY)end)
	DLib:RegisterDamageSource(_W, _MAGIC, 70, 40, _MAGIC, _AP, 0.60, function() return (player:CanUseSpell(_W) == READY)end)
	DLib:RegisterDamageSource(_E, _MAGIC, 70, 45, _MAGIC, _AP, 0.60, function() return (player:CanUseSpell(_E) == READY)end)
	DLib:RegisterDamageSource(_R, _MAGIC, 150, 100, _MAGIC, _AP, 0.75, function() return (player:CanUseSpell(_R) == READY)end)

	
	Config = scriptConfig("RyukLissandra","RyukLissandra")
	
	-- Key Binds
	Config:addSubMenu("Key Bindings","bind")
	Config.bind:addParam("active", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Config.bind:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Config.bind:addParam("auto", "Auto Spell", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("N"))
	Config.bind:addParam("interrupt", "Interrupt With R", SCRIPT_PARAM_ONKEYTOGGLE, true,string.byte("L"))
	Config.bind:addParam("gapClose", "W on Gap Close", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("K"))
	
	-- Options
	Config:addSubMenu("Configurations","options")
	Config.options:addParam("useUlt", "Use Ult", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("walkToMouse", "Walk To Mouse", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("highQ", "Use Q in Auto Only If High Chance", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("useEInCombo", "Use E In Combo", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("eRngChamp", "Range Between Claw and Enemy", SCRIPT_PARAM_SLICE, 450, 0, 900, 0)
	Config.options:addParam("selfUlt", "Self Ult", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("numEnemiesHit", "Number of Enemies Needed To Hit With R", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
	Config.options:addParam("numEnemies", "Number of Enemies to Self Ult", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
	Config.options:addParam("numAllies", "Number of Allies to Self Ult", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	Config.options:addParam("enemyRange", "Count Enemies Within Range", SCRIPT_PARAM_SLICE, 1000, 1000, 2000, 0)
	Config.options:addParam("allyRange", "Count Ally Within Range", SCRIPT_PARAM_SLICE, 1000, 1000, 2000, 0)
	Config.options:addParam("hitTwo", "Attempt to hit two with E -> W", SCRIPT_PARAM_ONOFF, true)
	-- Draw
	Config:addSubMenu("Draw","Draw")
	Config.Draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawW", "Draw W", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawe", "Draw E", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawr", "Draw R", SCRIPT_PARAM_ONOFF, true)
	Combo = {_Q, _W, _E, _R}
	DLib:AddToMenu(Config.Draw,Combo)
	-- OnlyUlt
	Config:addSubMenu("Only Ult","targets")
	
	for i, enemy in ipairs(GetEnemyHeroes()) do
		Config.targets:addParam(""..enemy.charName,"".. enemy.charName,SCRIPT_PARAM_ONOFF, true)
	end
	
	-- Orb Walker
	Orbwalker = SOW(VP)
	Config:addSubMenu("Orbwalker", "SOWorb")
	Orbwalker:LoadToMenu(Config.SOWorb)
	
	-- Target Selector
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY,qRng,DAMAGE_MAGIC,false)
	ts.name = "Lissandra"
	Config:addTS(ts)
	PrintChat("<font color='#E97FA5'> >> RyukLissandra Loaded!</font>")
	EnemyMinions = minionManager(MINION_ENEMY, qRng, player)
end

function findSecondEnemy(first,range)
	count = nil
	current = nil
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy.charName ~= first.charName and GetDistance(enemy) <= range then
			if count == nil then
				count = enemy.health
				current = enemy
			end
			if count > enemy.health then
				count = enemy.health
				current = enemy
			end
		end
	end
	return current
end

function numE(pos,range)
	local ChampCount = 0
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy and GetDistance(enemy,pos) <= range then
			ChampCount = ChampCount + 1
		end
	end		
	return ChampCount
end

function numA(range)
	local ChampCount = 0
	for i, ally in ipairs(GetAllyHeroes()) do
		if ally and GetDistance(ally) <= range then
			ChampCount = ChampCount + 1
		end
	end		
	return ChampCount
end

function shouldUlt(target)
	if target then
		if Config.targets[""..target.charName] then
			return true
		else
			return false
		end
	end
end
		

function OnTick()
	ts:update()
	EnemyMinions:update()
	
	if Config.bind.active then
		fullCombo(ts.target)
	end
	if Config.bind.harass then
		castQ(ts.target)
		if Config.options.walkToMouse then
			myHero:MoveTo(mousePos.x,mousePos.z)
		end
	end
	if Config.bind.auto then
		auto(ts.target)
	end
end

function auto(target) 
	if target then
		if Config.options.highQ then
			castQ(target,2)
		else
			castQ(target)
		end
		castW(target)
	end
end

function castDFG(target)
	if target and DFG:IsReady() and DFG:InRange(target) then
		DFG:Cast(target)
	end	
end

function castQ(target,chance)
	if target and Q:IsReady() and Q:IsInRange(target) then
		pos, qchance = Q:GetPrediction(target)
		if pos then
			if Config.options.highQ then
				if qchance >= 2 then
					Q:Cast(pos.x,pos.z)
				end
			else
				Q:Cast(pos.x,pos.z)
			end
		end
	end
end

function castW(target)
	if target and W:IsReady() and W:IsInRange(target) then
		W:Cast()
	end
end
function castE(target,range)
	if target and E:IsInRange(target) then
		
		if Config.options.hitTwo then
			enemy = findSecondEnemy(target,qRng)
			if enemy then
				pos1 = E:GetPrediction(target)
				pos2 = E:GetPrediction(enemy)
				if pos1 and pos2 and GetDistance(pos1,pos2) < wRng and EClaw == nil then
					pos3 = (pos1 + pos2)/2
					E:Cast(pos3.x,pos3.z)
				end
				if pos3 and eAndTarget(pos3,range) then
					E:Cast()
				end
			else
				pos = E:GetPrediction(target)
				if pos and EClaw == nil then
					E:Cast(pos.x,pos.z)
				end
				if pos and eAndTarget(pos,range) then
					E:Cast()
				end
			end
		else
			pos = E:GetPrediction(target)
			if pos and EClaw == nil then
				E:Cast(pos.x,pos.z)
			end
			if pos and eAndTarget(pos,range) then
				E:Cast()
			end
		end
	end
end

function castR(target)
	if target and R:IsReady() and R:IsInRange(target) then
		if Config.options.selfUlt and Config.options.numEnemies <= numE(myHero,Config.options.enemyRange) and Config.options.numAllies <= numA(Config.options.allyRange) and Config.options.numEnemiesHit <= numE(myHero,rRng) then
			R:Cast()
		else
			if shouldUlt(target) and Config.options.numEnemiesHit <= numE(target,rRng) then
				R:Cast(target)
			end
		end
	end
end

function fullCombo(target)
	if target then
		castDFG(target)
		castQ(target)
		castW(target)
		if Config.options.useEInCombo then
			castE(target,Config.options.eRngChamp)
		end
		castR(target)
	end
end

function OnDraw()
	if Config.Draw.drawq then
		DrawCircle(myHero.x,myHero.y,myHero.z,qRng,0xFFFF0000)
	end 
	if Config.Draw.draww then
		DrawCircle(myHero.x,myHero.y,myHero.z,wRng,0xFFFF0000)
	end
	if Config.Draw.drawe then
		DrawCircle(myHero.x,myHero.y,myHero.z,eRng,0xFFFF0000)
	end
	if Config.Draw.drawr then
		DrawCircle(myHero.x,myHero.y,myHero.z,rRng,0xFFFF0000)
	end
end

function OnProcessSpell(unit, spell)
	if Config.bind.gapClose and W:IsReady() then
		local jarvanAddition = unit.charName == "JarvanIV" and unit:CanUseSpell(_Q) ~= READY and (_R or _Q)
		if unit.type == 'obj_AI_Hero' and unit.team == TEAM_ENEMY then
			local spellName = spell.name
			if gapCloseList[unit.charName] and spellName == gapCloseList[unit.charName].spell and GetDistance(unit) < 2000 then
				if spell.target ~= nil and spell.target.name == myHero.name or gapCloseList[unit.charName].spell == 'blindmonkqtwo' then
					CastSpell(_W,myHero.x,myHero.z)
				end
			end
		end
	end
	if Config.bind.interrupt then
		if unit.type == 'obj_AI_Hero' and unit.team == TEAM_ENEMY and GetDistance(unit) <= rRng then
			local spellName = spell.name
			for i = 1, #champsToStun do
				if unit.charName == champsToStun[i].charName and spellName == champsToStun[i].spellName then
					if champsToStun[i].important == 0 then
						if R:IsReady() then
							CastSpell(_R, unit)
						end
					else
						if R:IsReady() then
							CastSpell(_R, unit)
						end
					end
				end
			end
		end
	end
end	

function OnCreateObj(object)
	if object.name:find("Lissandra_E_Missile.troy") then
		EClaw = object
	end
end

function OnDeleteObj(object)
	if object.name:find("Lissandra_E_Missile.troy") then
		EClaw = nil
	end
end

function eAndTarget(target,range)
	if target and EClaw then
		if GetDistance(target,EClaw) <= range then
			return true
		end
	end
	return false
end
