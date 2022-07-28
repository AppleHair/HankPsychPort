
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
	-- Static Lua sprites - line 55
	-----------------------------------
		HotdogStation - line 57
		Rock - line 61
		Ground - line 65
		RightCliff - line 68
		LeftCliff - line 72
		Sky - line 76

	-- Animated Lua sprites - line 80
	-----------------------------------
		helicopter - line 82
		Deimos & Sanford - line 88
		Lazer - line 105
		Speakers - line 111
		She friking flyy - line 114
		cutsceneClown - line 119
		gf-hot - line 126
		Climbers - line 133

	-- Offsets - line 155
	-----------------------------------
	-- Additions - line 167
	-----------------------------------
	-- Precaches - line 187
	-----------------------------------
]]
function onCreate()
	addLuaScript('custom_events/Blood Effect', true);

    		-- static lua sprites --
	
	makeLuaSprite('HotdogStation','NevadaHotdog', -800, -402);
	setLuaSpriteScrollFactor('HotdogStation', 1.36, 1.6);
	scaleObject('HotdogStation', 1.25, 1.25, true);

	makeLuaSprite('Rock','The Rock', -840, -472);
	setLuaSpriteScrollFactor('Rock', 1.36, 1.6);
	scaleObject('Rock', 1.32, 1.32, true);
	
	makeLuaSprite('Ground','NevadaGround', -795, -595);
	scaleObject('Ground', 1.45, 1.45, true);
	
	makeLuaSprite('RightCliff','NevadaRightCliff', -550, -450);
	setLuaSpriteScrollFactor('RightCliff', 0.5, 0.6);
	scaleObject('RightCliff', 1.45, 1.45, true);

	makeLuaSprite('LeftCliff','NevadaLeftCliff', -550, -450);
	setLuaSpriteScrollFactor('LeftCliff', 0.5, 0.6);
	scaleObject('LeftCliff', 1.45, 1.45, true);
	
	makeLuaSprite('Sky','NevadaSky', -366, -425);
	setLuaSpriteScrollFactor('Sky', 0.2, 0.1);
	scaleObject('Sky', 1.16, 1.16, true);
	
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
		setLuaSpriteScrollFactor(thing[i], 0.5, 0.6);
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

	makeAnimatedLuaSprite('She friking flyy','GF_go_bye_bye', 170, -80);
	addAnimationByPrefix('She friking flyy', 'AAA', 'She covered her self in oil', 24, true);
	-- setProperty('She friking flyy.visible', false);
	setProperty('She friking flyy.alpha', 0.00001);

	makeAnimatedLuaSprite('cutsceneClown','TrickyCutsceneClownAssets', 300, -240);
	addAnimationByPrefix('cutsceneClown', 'Turn', 'trickyturning', 24, false);
	addAnimationByPrefix('cutsceneClown', 'Fall', 'tikygetsshot', 24, true);
	scaleObject('cutsceneClown', 0.8, 0.8, true);
	-- setProperty('cutsceneClown.visible', false);
	setProperty('cutsceneClown.alpha', 0.00001);

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

			-- additions --
	
	addLuaSprite('Sky',false);
	addLuaSprite('helicopter',false);
	addLuaSprite('LeftCliff',false);
	addLuaSprite('RightCliff',false);
	addLuaSprite('Deimos',false);
	addLuaSprite('Sanford',false);
	addLuaSprite('Ground',false);
	addLuaSprite('Speakers',false);
	addLuaSprite('cutsceneClown',false);
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
	precacheImage('TrickyCutsceneClown');
	precacheImage('GF_go_bye_bye');
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
    	--Events--
----------------------------------------------------------------------------------------------------------------------

local StopDeimos = false; -- used to make Deimos stop his idle animation
local StopSanford = false; -- used to make Sanford stop his idle animation
local StopLazer = false; -- used to make the lazer stop his idle animation
local clownAndLazer = false; -- used to check if tricky entered the stage. helps for executing clown-lazer behavior
local WalkingHotDogGF = false; -- used for checking if gf is walking to stop her idle animation
local whatTheyDo = {1,2,3; n=3}; -- used to tell each climber what to be (1 = grunt, 2 = agent, 3 = engineer)
						    	 -- (whatTheyDo[1] = middle, whatTheyDo[2] = left, whatTheyDo[3] = right)
local doYouEvenDo = {1,0,0; n=3}-- 0 = don't do it, 1 = do it

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
		StopDeimos = true; 
		StopSanford = true;
		runTimer('HandsUpTimer', 0.3, 1);
	end
	if name == 'Tricky Kicks GF' then
		-- setProperty('Lazer.visible', false);
		setProperty('Lazer.alpha', 0.00001);
		-- setProperty('She friking flyy.visible', true);
		setProperty('She friking flyy.alpha', 1);
		setProperty('She friking flyy.velocity.x', 15000);
	end
	if name == 'Tricky Lookin' then
		triggerEvent('Set Blood Effect Pos', 250, -150);
		setProperty('Lazer.visible', false);
		setProperty('gf.visible', false);
		-- setProperty('cutsceneClown.visible', true);
		setProperty('cutsceneClown.alpha', 1);
		objectPlayAnimation('cutsceneClown', 'Turn', true);
	end
	if name == 'Tricky Fallin' then
    	triggerEvent('Add Blood Effect', '', '');
		objectPlayAnimation('cutsceneClown', 'Fall', true);
		setProperty('cutsceneClown.y', -490);
		doTweenY('ClownGoUp', 'cutsceneClown', -1000, 0.4, 'sineInOut');
	end

	if name == 'HotDogGF Appears' then
		WalkingHotDogGF = true;
		-- setProperty('gf-hot.visible', true);
		setProperty('gf-hot.alpha', 1);
		playAnim('gf-hot', 'Walk', false);
		doTweenX('HotGFWalksIn', 'gf-hot', getProperty('gf-hot.x') - HotGFMovementAmount, 0.8, 'linear');
	end
	
	if name == 'They climb and get shot at' then
		math.randomseed(score + curStep);-- B)
		for i=1,table.getn(whatTheyDo) do
			whatTheyDo[i] = getRandomInt(1,3);
			doYouEvenDo[i] = math.random(0,1); -- getRandomInt() and getRandomBool() didn't work correctly for some reason,
											   -- so I'm using math.random() and math.randomseed(score + curStep) to get a random number here
			if doYouEvenDo[i] == 1 then
				objectPlayAnimation('climber' .. i, 'Climb' .. whatTheyDo[i], true);
				-- setProperty('climber' .. i .. '.visible', true);
				setProperty('climber' .. i .. '.alpha', 1);
			end
		end
		if arraySum(doYouEvenDo) ~= 0 then
			runTimer('ShootTimer', 0.55, 1);
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
		--Tween Completions--
--------------------------------------------------------------------------------------------------------------------
function onTweenCompleted(tag)
	if tag == 'ClownGoUp' then
		setObjectOrder('cutsceneClown', getObjectOrder('cutsceneClown') - 2);
		setObjectOrder('Ground', getObjectOrder('Ground') + 1);
		setObjectOrder('Speakers', getObjectOrder('Speakers') + 1);
		doTweenY('ClownGoDown', 'cutsceneClown', 600, 0.7, 'sineInOut');
	end
	if tag == 'HotGFWalksIn' then
		WalkingHotDogGF = false;
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
		StopLazer = true;
	end
	if tag == 'ShootTimer' then
		playSound('death sound', 0.5);
		if doYouEvenDo[1] == 1 or doYouEvenDo[3] == 1 then
			playAnim('Deimos', 'Shoot', false);
			StopDeimos = true;
		end
		if doYouEvenDo[1] == 1 or doYouEvenDo[2] == 1 then
			playAnim('Sanford', 'Shoot', false);
			StopSanford = true;
		end
		for i=1,table.getn(whatTheyDo) do
			if doYouEvenDo[i] == 1 then
				objectPlayAnimation('climber' .. i, 'Shoot' .. whatTheyDo[i], true);
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
	if not clownAndLazer then
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
	getProperty('gf.animation.curAnim.name') == 'danceRight') and clownAndLazer then
		-- setProperty('Lazer.visible', true);
		setProperty('Lazer.alpha', 1);
	end

---------------------------------------------------
        --Boop Control--
---------------------------------------------------
	if not StopDeimos then
		playAnim('Deimos', 'Boop', true);
	end
	if not StopSanford then
		playAnim('Sanford', 'Boop', true);
	end
	if not StopLazer then
		playAnim('Lazer', 'Boop', true);
		if getProperty('Lazer.alpha') == 1 then
			if clownAndLazer then 
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
	if not WalkingHotDogGF then
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
	clownAndLazer = gfName == 'tricky' and getProperty('gf.visible');
	for i=1,3 do
		if getProperty('climber' .. i .. '.animation.curAnim.finished') then
			-- setProperty('climber' .. i .. '.visible', false);
			setProperty('climber' .. i .. '.alpha', 0.00001);
		end
	end
	if getProperty('Deimos.animation.curAnim.finished') and StopDeimos then
		StopDeimos = false;
	end
	if getProperty('Sanford.animation.curAnim.finished') and StopSanford then
		StopSanford = false;
	end
	if getProperty('Lazer.animation.curAnim.finished') and StopLazer then
		StopLazer = false;
	end
end