require "VPrediction"
require "SourceLib"
if myHero.charName ~= "Viktor" then return end
local version = 0.95
local autoUpdate   = true
local scriptName = "RyukViktor"
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
    SourceUpdater(scriptName, version, "raw.github.com", "/RyukOP/Scripts/master/RyukViktor.lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/RyukOP/Scripts/master/RyukViktor.version"):SetSilent(silentUpdate):CheckUpdate()
end
--[[






	--				GAP CLOSER
					
					
					
					
--]]

isAGapcloserUnit = {
       ['Ahri']        = {true, spell = _R, 	               range = 450,   projSpeed = 2200},
        ['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
        ['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, }, -- Targeted ability
        ['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, }, -- Targeted ability
        ['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, }, -- Targeted ability
        ['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
        ['Graves']      = {true, spell = _E,                  range = 425,   projSpeed = 2000, exeption = true },
        ['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
        ['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, }, -- Targeted ability
        ['JarvanIV']    = {true, spell = jarvanAddition,      range = 770,   projSpeed = 2000, }, -- Skillshot/Targeted ability
        ['Jax']         = {true, spell = _Q,                  range = 700,   projSpeed = 2000, }, -- Targeted ability
        ['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, }, -- Targeted ability
		['Katarina']	 = {true, spell = _E,                   range = 700,   projSpeed = 2000, },
        ['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
        ['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
        ['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
        ['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
        ['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500, },
        ['Maokai']      = {true, spell = _Q,                  range = 600,   projSpeed = 1200, }, -- Targeted ability	
		['MasterYi']	=  {true, spell = _Q,	               range = 600,   projSpeed = 2200, }, -- Targeted
        ['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, }, -- Targeted ability
        ['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, }, -- Targeted ability
        ['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, }, -- Targeted ability
        --['Quinn']       = {true, spell = _E,                  range = 725,   projSpeed = 2000, }, -- Targeted ability
        ['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
        ['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
        ['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
        ['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
        ['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
        ['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, }, -- Targeted ability
}
--[[




		--INTERRUPT
		
		
		
--]]

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
                { charName = "Pantheon",        spellName = "Pantheon_GrandSkyfall_Jump" , important = 0},
                { charName = "Varus",           spellName = "VarusQ" ,                     important = 1},
                { charName = "Caitlyn",         spellName = "CaitlynAceintheHole" ,        important = 1},
                { charName = "MissFortune",     spellName = "MissFortuneBulletTime" ,      important = 1},
                { charName = "Warwick",         spellName = "InfiniteDuress" ,             important = 0}
}

function OnLoad()
	VP = VPrediction()
	qRng, wRng, eRng, rRng = 600, 625, 1040, 700
	Q = Spell(_Q, qRng)
	W = Spell(_W, wRng):SetSkillshot(VP, SKILLSHOT_CIRCULAR, 300, 0.5, 1750, false)
	E = Spell(_E, eRng):SetSkillshot(VP, SKILLSHOT_LINEAR, 90, 0.5, 1210, false)
	R = Spell(_R, rRng):SetSkillshot(VP, SKILLSHOT_CIRCULAR, 250, 0.5, 1210, false)
	DFG = Item(3128,750)
	Config = scriptConfig("RyukViktor","RyukViktor")
	-- Key Binds
	Config:addSubMenu("Key Bindings","bind")
	Config.bind:addParam("active", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Config.bind:addParam("stun", "Stun Prediction", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	Config.bind:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Config.bind:addParam("auto", "Auto Spell", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("N"))
	Config.bind:addParam("interrupt", "Interrupt With W/R", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("L"))
	Config.bind:addParam("gapClose", "W on Gap Close", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("K"))
	-- Options
	Config:addSubMenu("Configurations","options")
	Config.options:addParam("useUlt", "Use Ult", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("useStun", "Use Stun", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("useW", "Interrupt with W", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("useR", "Interrupt with R", SCRIPT_PARAM_ONOFF, true)
	Config.options:addParam("goodE", "Only Use E If High Chance (For Auto Spell)",SCRIPT_PARAM_ONOFF, false)
	-- Draw
	Config:addSubMenu("Draw","Draw")
	Config.Draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("draww", "Draw W", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawe", "Draw E", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawr", "Draw R", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawtext", "Draw Text", SCRIPT_PARAM_ONOFF, true)
	Config:addSubMenu("Only Ult","targets")
	enemyTable = {}
	for i, enemy in ipairs(GetEnemyHeroes()) do
		Config.targets:addParam(""..enemy.charName,"".. enemy.charName,SCRIPT_PARAM_ONOFF, true)
		table.insert(enemyTable,enemy.charName)
	end
	ts = TargetSelector(TARGET_LESS_CAST,eRng,DAMAGE_MAGIC,false)
	ts.name = "Viktor"
	Config:addTS(ts)
	PrintChat("<font color='#E97FA5'> >> RyukViktor Loaded!</font>")
end

function OnTick()
	ts:update()
	if Config.bind.active then 
		fullCombo()
	end
	if ts.target then
		stormControl(ts.target)
	end
	if Config.bind.stun then
		stun()
	end
	if Config.bind.harass then
		harass()
	end
	if Config.bind.auto then
		Auto()
	end
end

function Auto()
	if ts.target then
		if Q:IsReady() and Q:IsInRange(ts.target,myHero) then
			CastSpell(_Q,ts.target)
		end
		if E:IsReady() and E:IsInRange(ts.target, myHero) then
			pose, chance = E:GetPrediction(ts.target)
			if pose ~= nil then
				if Config.options.goodE then
					if chance >= 2 then
						if GetDistance(ts.target) < 540 then
							Packet('S_CAST', { spellId = SPELL_3, fromX = ts.target.x, fromY = ts.target.z, toX = pose.x, toY = pose.z }):send()
						else
						start = Vector(myHero) + (myHero - pose)*(-550/GetDistance(pose))
						Packet('S_CAST', { spellId = SPELL_3, fromX = start.x, fromY = start.z, toX = pose.x, toY = pose.z }):send()		
						end
					end
				else
					if GetDistance(ts.target) < 540 then
						Packet('S_CAST', { spellId = SPELL_3, fromX = ts.target.x, fromY = ts.target.z, toX = pose.x, toY = pose.z }):send()
					else
						start = Vector(myHero) + (myHero - pose)*(-550/GetDistance(pose))
						Packet('S_CAST', { spellId = SPELL_3, fromX = start.x, fromY = start.z, toX = pose.x, toY = pose.z }):send()		
					end
				end
			end
		end
	end
end

function shouldUlt()
	if ts.target then
		if Config.targets[""..ts.target.charName] then
			return true
		else
			return false
		end
	end
end
					

function harass()
	if ts.target then
		if E:IsReady() and E:IsInRange(ts.target, myHero) then
			pose = E:GetPrediction(ts.target)
			if pose ~= nil then
				if GetDistance(ts.target) < 540 then
					Packet('S_CAST', { spellId = SPELL_3, fromX = ts.target.x, fromY = ts.target.z, toX = pose.x, toY = pose.z }):send()
				else
					start = Vector(myHero) + (myHero - pose)*(-550/GetDistance(pose))
					Packet('S_CAST', { spellId = SPELL_3, fromX = start.x, fromY = start.z, toX = pose.x, toY = pose.z }):send()
				end
			end
		end
		if Q:IsReady() and Q:IsInRange(ts.target,myHero) then
			CastSpell(_Q,ts.target)
		end
	end
end

function isFacing(source, target, lineLength)
	local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
	local sourcePos = Vector(source.x, source.z)
	sourceVector = (sourceVector-sourcePos):normalized()
	sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
	return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
end

function stun()
	if ts.target then
		if W:IsReady() and W:IsInRange(ts.target,myHero) then
			posw = W:GetPrediction(ts.target)
			if posw ~= nil then
					if isFacing(ts.target,myHero) then
						pw = Vector(posw) - 150 * (Vector(posw) - Vector(myHero)):normalized()
					else
						pw = Vector(posw) + 150 * (Vector(posw) - Vector(myHero)):normalized()
					end
					CastSpell(_W,pw.x,pw.z)
			end
		end
	end
end

function fullCombo()
	if ts.target then
		-- Casting DFG
		if DFG:IsReady() and DFG:InRange(ts.target) then
			DFG:Cast(ts.target)
		end	
		-- Casting Q
		if Q:IsReady() and Q:IsInRange(ts.target,myHero) then
			CastSpell(_Q,ts.target)
		end
		-- Casting W
		if W:IsReady() and W:IsInRange(ts.target,myHero) and Config.options.useStun then
			posw = W:GetPrediction(ts.target)
			if posw ~= nil then
				if W:IsInRange(ts.target,myHero) and W:IsReady() then
					if isFacing(ts.target,myHero) then
						pw = Vector(posw) - 150 * (Vector(posw) - Vector(ts.target)):normalized()
					else
						pw = Vector(posw) + 150 * (Vector(posw) - Vector(ts.target)):normalized()
					end
					CastSpell(_W,pw.x,pw.z)
				end
			end
		end
		-- Casting E
		if E:IsReady() and E:IsInRange(ts.target, myHero) then
			pose = E:GetPrediction(ts.target)
			if pose ~= nil then
				if GetDistance(ts.target) < 540 then
					Packet('S_CAST', { spellId = SPELL_3, fromX = ts.target.x, ts.target.z, toX = pose.x, toY = pose.z }):send()
				else
					--start = Vector(myHero) - 540 * (Vector(myHero) - Vector(ts.target)):normalized()
					start = Vector(myHero) + (myHero - pose)*(-550/GetDistance(pose))
					Packet('S_CAST', { spellId = SPELL_3, fromX = start.x, fromY = start.z, toX = pose.x, toY = pose.z }):send()
				end
			end
		end
		-- Casting R
		if Config.options.useUlt and R:IsReady() and R:IsInRange(ts.target, myHero) and shouldUlt() then
			posr = R:GetPrediction(ts.target)
			if posr ~= nil then
				R:Cast(ts.target.x,ts.target.z)
			end
		end
	end
end


function stormControl(target)
	if myHero:GetSpellData(_R).name == "viktorchaosstormguide" then
		CastSpell(_R, target.x, target.z)
	end
end

function Damage(target)
  if target then
    local qDmg = getDmg("Q", target, myHero)
    local eDmg = getDmg("E", target, myHero)
    local rDmg = getDmg("R", target, myHero)
    local dfgDmg = (GetInventorySlotItem(3128) ~= nil and getDmg("DFG", target, myHero)) or 0
    local damageAmp = (GetInventorySlotItem(3128) ~= nil and 1.2) or 1
		local currentDamage = 0
    
    if Q:IsReady() then
     currentDamage = currentDamage + qDmg
    end
   
    if E:IsReady() then
     currentDamage = currentDamage + eDmg
    end
  
	if R:IsReady() then
		currentDamage = currentDamage + rDmg
	end
	 
    if DFG:IsReady() then
     currentDamage = (currentDamage * damageAmp) + dfgDmg
    end
		return currentDamage
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
	if Config.drawtext then
		for i, target in ipairs(GetEnemyHeroes()) do
			if ValidTarget(target) and target.team ~= myHero.team and target.dead ~= true then
				if Damage(target) > target.health then
					PrintFloatText(target,0,"Killable")
				end
			end
		end
	end
end

function OnProcessSpell(unit, spell)
	if Config.bind.gapClose then
		local jarvanAddition = unit.charName == "JarvanIV" and unit:CanUseSpell(_Q) ~= READY and _R or _Q 
		if unit.type == 'obj_AI_Hero' and unit.team == TEAM_ENEMY and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil and W:IsReady() then
			if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) then
				if spell.target ~= nil and spell.target.name == myHero.name or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
					CastSpell(_W, myHero.x, myHero.z)
				end
			end
		end
	end
	if Config.bind.interrupt then
		if unit.type == 'obj_AI_Hero' and unit.team == TEAM_ENEMY and GetDistance(unit) < (wRng or rRng) then
		   	local spellName = spell.name
			for i = 1, #champsToStun do
				if unit.charName == champsToStun[i].charName and spellName == champsToStun[i].spellName then
					if champsToStun[i].important == 0 then
						if Config.options.useW and W:IsReady() and W:IsInRange(ts.target,myHero) then
							CastSpell(_W,unit.x,unit.z)
						end
						if Config.options.useR and R:IsReady() and R:IsInRange(ts.target,myHero) then
							CastSpell(_R,unit.x,unit.z)
						end
					else
						if Config.options.useW and W:IsReady() and W:IsInRange(ts.target,myHero) then
							CastSpell(_W,unit.x,unit.z)
						end
						if Config.options.useR and R:IsReady() and R:IsInRange(ts.target,myHero) then
							CastSpell(_R,unit.x,unit.z)
						end
					end
				end
			end
		end
	end	
end

