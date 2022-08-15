
-- how much does hotdog gf move
local HotGFMovementAmount = 350;

-- true = left  false = right
local DanceDir = false;

--[[
	Sums all the values in an array

	arr - Array to sum
]]
function arraySum(arr)
	local sum = 0;
	for i=1,table.getn(arr) do
		sum = sum + arr[i]
	end
	return sum
end

--[[
-------------------------------------------------------------------
			onCreate - Table of contents
-------------------------------------------------------------------
	-- Static Lua sprites - line 54
	-----------------------------------
		HotdogStation - line 56
		Rock - line 60
		Ground - line 64
		RightCliff - line 67
		LeftCliff - line 71
		Sky - line 75
		She friking flyy - line 79

	-- Animated Lua sprites - line 83
	-----------------------------------
		helicopter - line 85
		Deimos & Sanford - line 91
		Lazer - line 108
		Speakers - line 114
		gf-hot - line 117
		Climbers - line 124

	-- Offsets - line 146
	-----------------------------------
	-- Adding to PlayState - line 158
	-----------------------------------
	-- Precaches - line 177
	-----------------------------------
]]
function onCreate()
	addLuaScript('custom_events/Blood Effect', true);

    		-- static lua sprites --
	
	makeLuaSprite('HotdogStation','NevadaHotdog', 1010, 441);
	setLuaSpriteScrollFactor('HotdogStation', 1.36, 1.35);
	scaleObject('HotdogStation', 1.25, 1.25, true);

	makeLuaSprite('Rock','The Rock', -772, 707);
	setLuaSpriteScrollFactor('Rock', 1.36, 1.35);
	scaleObject('Rock', 1.32, 1.32, true);
	
	makeLuaSprite('Ground','NevadaGround', -795, 458);
	scaleObject('Ground', 1.45, 1.45, true);
	
	makeLuaSprite('RightCliff','NevadaRightCliff', 1173, -246);
	setLuaSpriteScrollFactor('RightCliff', 0.5, 0.5);
	scaleObject('RightCliff', 1.45, 1.45, true);

	makeLuaSprite('LeftCliff','NevadaLeftCliff', -550, -213);
	setLuaSpriteScrollFactor('LeftCliff', 0.5, 0.5);
	scaleObject('LeftCliff', 1.45, 1.45, true);
	
	makeLuaSprite('Sky','NevadaSky', -366, -425);
	setLuaSpriteScrollFactor('Sky', 0.2, 0.1);
	scaleObject('Sky', 1.16, 1.16, true);
	
	makeLuaSprite('She friking flyy','GF go bye bye', 170, -80);
	-- setProperty('She friking flyy.visible', false);
	setProperty('She friking flyy.alpha', 0.00001);
	
			-- animated lua sprites --
	
	makeAnimatedLuaSprite('helicopter', 'helicopter', -1323, -270);
	addAnimationByPrefix('helicopter', 'Fly', 'Fly', 24, true);
	setScrollFactor('helicopter', 0.4, 0.3);
	scaleObject('helicopter', 1.2, 1.2, true);
	

	makeAnimatedLuaSprite('Deimos','Deimos', -440, -205);
	makeAnimatedLuaSprite('Sanford','Sanford', 1230, -220);

	local thing = {};
	thing[1] = 'Deimos';
	thing[2] = 'Sanford';

	for i=1,2 do
		setLuaSpriteScrollFactor(thing[i], 0.5, 0.5);
		addAnimationByPrefix(thing[i], 'Boop', thing[i] .. ' Boop', 24, false);
		addAnimationByPrefix(thing[i], 'Appear', thing[i] .. ' Appear', 24, false);
		addAnimationByPrefix(thing[i], 'Shoot', thing[i] .. ' Shoot', 24, false);
		-- setProperty(thing[i] .. '.visible', false);
		setProperty(thing[i] .. '.alpha', 0.00001);
	end
	thing = nil;
	
	makeAnimatedLuaSprite('Lazer','LazerDot', 525, -20);
	addAnimationByPrefix('Lazer', 'Flash', 'LazerDot Flash', 24, false);
	addAnimationByPrefix('Lazer', 'Boop', 'LazerDot Boop', 24, false);
	scaleObject('Lazer', 1.5, 1.5, true);
	setProperty('Lazer.visible', false);

	makeAnimatedLuaSprite('Speakers','speakers', 205, 240);
	addAnimationByPrefix('Speakers', 'Boop', 'speakers', 24, false);

	makeAnimatedLuaSprite('gf-hot','GFHotdog', 1530, 200);
	addAnimationByIndices('gf-hot', 'Boop-left', 'GFStandingWithHotDog', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14', 24);
	addAnimationByIndices('gf-hot', 'Boop-right', 'GFStandingWithHotDog', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29', 24);
	addAnimationByPrefix('gf-hot', 'Walk', 'GFStandingWithHotDogWalk', 24, true);
	-- setProperty('gf-hot.visible', false);
	setProperty('gf-hot.alpha', 0.00001);
	
	makeAnimatedLuaSprite('climber1','Climbers', 330, -157);
	makeAnimatedLuaSprite('climber2','Climbers', -300, 183);
	makeAnimatedLuaSprite('climber3','Climbers', 1170, 210);
	setProperty('climber3.angle', 5);
	setProperty('climber2.angle', -3.5);

	local thing = {};
	thing[1] = 'grunt';
	thing[2] = 'agent';
	thing[3] = 'eng';

	for i=1,3 do
		for j=1,3 do
			addAnimationByIndices('climber' .. i, 'Climb' .. j, thing[j] .. 'climbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
			addAnimationByIndices('climber' .. i, 'Shoot' .. j, thing[j] .. 'climbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
		end
		-- setProperty('climber' .. i .. '.visible', false);
		setProperty('climber' .. i .. '.alpha', 0.00001);
		scaleObject('climber' .. i, 0.85, 0.85, true);
	end
	thing = nil;

			-- offsets --
	-- Deimos
	addOffset('Deimos', 'Appear', 80, 440);
	addOffset('Deimos', 'Shoot', 5, 0);

	-- Sanford
	addOffset('Sanford', 'Appear', -3, 376);
	addOffset('Sanford', 'Shoot', 200, 14);

	-- Lazer
	addOffset('Lazer', 'Flash', -11, -15);

			-- Adding to PlayState --
	
	addLuaSprite('Sky',false);
	addLuaSprite('helicopter',false);
	addLuaSprite('LeftCliff',false);
	addLuaSprite('RightCliff',false);
	addLuaSprite('Deimos',false);
	addLuaSprite('Sanford',false);
	addLuaSprite('Ground',false);
	addLuaSprite('Speakers',false);
	for i=1,3 do
		addLuaSprite('climber' .. i,false);
	end
	addLuaSprite('gf-hot', false);
	addLuaSprite('She friking flyy',true);
	addLuaSprite('HotdogStation',true);
	addLuaSprite('Rock',true);
	addLuaSprite('Lazer',true);

			-- precaches --

	precacheSound('death sound');

	precacheImage('Climbers');
	precacheImage('GFHotdog');
	precacheImage('GF go bye bye');
	precacheImage('LazerDot');
	precacheImage('helicopter');
	precacheImage('speakers');
	precacheImage('Sanford');
	precacheImage('Deimos');
end

















----------------------------------------------------------------------------------------------------------------------
		-- Camera Shit --
----------------------------------------------------------------------------------------------------------------------
local dadCamPos = {419.5, 398.5};
local bfCamPos = {703.5, 398.5};

function onMoveCamera(focus)
	if focus == 'dad' then
		setProperty('camFollow.x', dadCamPos[1]);
		setProperty('camFollow.y', dadCamPos[2]);
	end
	if focus == 'boyfriend' then
		setProperty('camFollow.x', bfCamPos[1]);
		setProperty('camFollow.y', bfCamPos[2]);
	end
end

----------------------------------------------------------------------------------------------------------------------
    	-- Events --
----------------------------------------------------------------------------------------------------------------------

local stopDeimos = false; -- used to make Deimos stop his idle animation
local stopSanford = false; -- used to make Sanford stop his idle animation
local stopLazer = false; -- used to make the lazer stop his idle animation
local stopHotDogGF = false; -- used to make hotdog gf stop her idle animation
local climberSkin = {1,2,3; n=3}; -- used to tell each climber what skin it should use (1 = grunt, 2 = agent, 3 = engineer)
						    	 -- (climberSkin[1] = middle, climberSkin[2] = left, climberSkin[3] = right)
local appearList = {1,0,0; n=3}-- 0 = appear, 1 = don't appear

function onEvent(name, value1, value2)
	if name == 'Heli Appear' then
		setProperty('helicopter.velocity.x', 450);
	end

	if name == 'Deimos&Sanford Appear' then
		dadCamPos[2] = dadCamPos[2] - 80;
		bfCamPos[2] = bfCamPos[2] - 80;
		-- setProperty('Deimos.visible', true);
		setProperty('Deimos.alpha', 1);
		-- setProperty('Sanford.visible', true);
		setProperty('Sanford.alpha', 1);
		playAnim('Deimos', 'Appear', false);
		playAnim('Sanford', 'Appear', false);
		stopDeimos = true; 
		stopSanford = true;
		runTimer('HandsUpTimer', 0.3, 1);
	end

	if name == 'Play Animation' then
		if value2 == 'gf' then
			if value1 == 'Enter' then
				-- setProperty('Lazer.visible', false);
				setProperty('Lazer.alpha', 0.00001);
				-- setProperty('She friking flyy.visible', true);
				setProperty('She friking flyy.alpha', 1);
				setProperty('She friking flyy.velocity.x', 15000);
			end
			if value1 == 'Turn' then
				triggerEvent('Set Blood Effect Pos', 220, -150);
				setProperty('Lazer.visible', false);
				setProperty('gf.specialAnim', false);
				setProperty('gf.stunned', true);
			end
			if value1 == 'Fall' then
				triggerEvent('Add Blood Effect', '', '');
				doTweenY('ClownGoUp', 'gf', -550, 0.3, 'sineOut');
			end
		end
	end

	if name == 'HotDogGF Appears' then
		stopHotDogGF = true;
		-- setProperty('gf-hot.visible', true);
		setProperty('gf-hot.alpha', 1);
		playAnim('gf-hot', 'Walk', false);
		doTweenX('HotGFWalksIn', 'gf-hot', getProperty('gf-hot.x') - HotGFMovementAmount, 0.8, 'linear');
	end
	
	if name == 'They climb and get shot at' then
		math.randomseed(os.time());-- os.time() is back baby!!
		for i=1,table.getn(climberSkin) do

			climberSkin[i] = math.random(1,3);
			appearList[i] = math.random(0,1);

			if appearList[i] == 1 then
				objectPlayAnimation('climber' .. i, 'Climb' .. climberSkin[i], true);
				-- setProperty('climber' .. i .. '.visible', true);
				setProperty('climber' .. i .. '.alpha', 1);
			end
		end
		if arraySum(appearList) ~= 0 then
			runTimer('ShootTimer', 0.55, 1);
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
		--Tween Completions--
--------------------------------------------------------------------------------------------------------------------
function onTweenCompleted(tag)
	if tag == 'ClownGoUp' then
		setObjectOrder('gfGroup', getObjectOrder('Ground'));
		doTweenY('ClownGoDown', 'gf', 1000, 0.7, 'sineIn');
	end
	if tag == 'HotGFWalksIn' then
		stopHotDogGF = false;
	end
end

--------------------------------------------------------------------------------------------------------------------
		--Timer Completions--
--------------------------------------------------------------------------------------------------------------------
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'HandsUpTimer' then
		triggerEvent('Play Animation', 'Raise', 'gf');
		triggerEvent('Alt Idle Animation', 'gf', '-alt');
		setProperty('Lazer.visible', true);
		playAnim('Lazer', 'Flash', false);
		stopLazer = true;
	end
	if tag == 'ShootTimer' then
		playSound('death sound', 0.5);
		if appearList[1] == 1 or appearList[3] == 1 then
			playAnim('Deimos', 'Shoot', false);
			stopDeimos = true;
		end
		if appearList[1] == 1 or appearList[2] == 1 then
			playAnim('Sanford', 'Shoot', false);
			stopSanford = true;
		end
		for i=1,table.getn(climberSkin) do
			if appearList[i] == 1 then
				objectPlayAnimation('climber' .. i, 'Shoot' .. climberSkin[i], true);
				-- setProperty('climber' .. i .. '.visible', true);
				setProperty('climber' .. i .. '.alpha', 1);
			end
		end
	end
end

---------------------------------------------------
		--Lazer Visibility--       Sequel - line 347
---------------------------------------------------
function opponentNoteHit(id, direction, noteType, isSustainNote)
	if not gfName == 'tricky' then
		return;
	end
	if noteType == 'GF Sing' then
		-- setProperty('Lazer.visible', false);
		setProperty('Lazer.alpha', 0.00001);
	end
end

function onBeatHit()
-----------         -----------
  --Lazer Visibility Sequel--
-----------  		-----------
	if (getProperty('gf.animation.curAnim.name') == 'danceLeft' or 
	getProperty('gf.animation.curAnim.name') == 'danceRight') and gfName == 'tricky' then
		-- setProperty('Lazer.visible', true);
		setProperty('Lazer.alpha', 1);
	end

---------------------------------------------------
        --Boop Control--
---------------------------------------------------
	if not stopDeimos then
		playAnim('Deimos', 'Boop', true);
	end
	if not stopSanford then
		playAnim('Sanford', 'Boop', true);
	end
	if not stopLazer then
		playAnim('Lazer', 'Boop', true);
		if getProperty('Lazer.alpha') == 1 then
			if gfName == 'tricky' then 
				if getProperty('Lazer.x') ~= 700 and
				getProperty('Lazer.y') ~= 10 then
					setProperty('Lazer.x', 700);
					setProperty('Lazer.y', 10);
				end
			elseif getProperty('Lazer.x') ~= 525 and
			getProperty('Lazer.y') ~= -20 then
				setProperty('Lazer.x', 525);
				setProperty('Lazer.y', -20);
			end 
		end
	end
	if not stopHotDogGF then
		if DanceDir then
			playAnim('gf-hot', 'Boop-left', true);
			DanceDir = false;
		else
			playAnim('gf-hot', 'Boop-right', true);
			DanceDir = true;
		end
	end
	playAnim('Speakers', 'Boop', true);
end

---------------------------------------------------
	--Object Visibility and Animation Controls--
---------------------------------------------------
function onUpdate(elapsed)
	for i=1,3 do
		if getProperty('climber' .. i .. '.animation.curAnim.finished') then
			-- setProperty('climber' .. i .. '.visible', false);
			setProperty('climber' .. i .. '.alpha', 0.00001);
		end
	end
	if getProperty('Deimos.animation.curAnim.finished') and stopDeimos then
		stopDeimos = false;
	end
	if getProperty('Sanford.animation.curAnim.finished') and stopSanford then
		stopSanford = false;
	end
	if getProperty('Lazer.animation.curAnim.finished') and stopLazer then
		stopLazer = false;
	end
end