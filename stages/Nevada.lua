
-- how much does hotdog gf move
local HotGFMovementAmount = 350;

-- true = left  false = right
local DanceDir = false;

--[[
	Sums all the values in an array

	arr - Array to sum
]]
local function arraySum(arr)
	local sum = 0;
	for i=1, #arr do
		sum = sum + arr[i]
	end
	return sum
end

--[[
-------------------------------------------------------------------
			onCreate - Table of contents
-------------------------------------------------------------------
	-- Static Lua sprites - line 57
	-----------------------------------
		HotdogStation - line 59
		Rock - line 63
		Ground - line 67
		RightCliff - line 70
		LeftCliff - line 74
		Sky - line 78
		She friking flyy - line 82

	-- Animated Lua sprites - line 86
	-----------------------------------
		helicopter - line 88
		Deimos & Sanford - line 94
		Lazer - line 112
		Speakers - line 118
		gf-hot - line 121
		Climbers - line 128

	-- tips on sprites in Psych Engine Lua - Line 149
	-----------------------------------
	-- Offsets - line 158
	-----------------------------------
	-- Adding to PlayState - line 170
	-----------------------------------
	-- Precaches - line 189
	-----------------------------------
]]
function onCreate()
	-- we add the blood effect script
	addLuaScript('custom_events/Blood Effect', true);

    		-- static lua sprites --
	
	makeLuaSprite('HotdogStation','NevadaHotdog', 1010, 441);
	setLuaSpriteScrollFactor('HotdogStation', 1.38, 1.35);
	scaleObject('HotdogStation', 1.25, 1.25, true);

	makeLuaSprite('Rock','The Rock', -776, 704);
	setLuaSpriteScrollFactor('Rock', 1.38, 1.35);
	scaleObject('Rock', 1.32, 1.32, true);
	
	makeLuaSprite('Ground','NevadaGround', -795, 458);
	scaleObject('Ground', 1.45, 1.45, true);
	
	makeLuaSprite('RightCliff','NevadaRightCliff', 1173, -246);
	setLuaSpriteScrollFactor('RightCliff', 0.5, 0.5);
	scaleObject('RightCliff', 1.45, 1.45, true);

	makeLuaSprite('LeftCliff','NevadaLeftCliff', -550, -213);
	setLuaSpriteScrollFactor('LeftCliff', 0.5, 0.5);
	scaleObject('LeftCliff', 1.45, 1.45, true);
	
	makeLuaSprite('Sky','NevadaSky', -345, -425);
	setLuaSpriteScrollFactor('Sky', 0.1, 0.1);
	scaleObject('Sky', 1.16, 1.16, true);
	
	makeLuaSprite('She friking flyy','GF go bye bye', 170, -70);
	-- setProperty('She friking flyy.visible', false);
	setProperty('She friking flyy.alpha', 0.00001);
	
			-- animated lua sprites --
	
	makeAnimatedLuaSprite('helicopter', 'helicopter', -1200, -270);
	addAnimationByPrefix('helicopter', 'Fly', 'Fly', 24, true);
	setScrollFactor('helicopter', 0.4, 0.3);
	scaleObject('helicopter', 1.15, 1.15, true);
	

	makeAnimatedLuaSprite('Deimos','Deimos', -423, -224);
	makeAnimatedLuaSprite('Sanford','Sanford', 1210, -215);

	local thing = {};
	thing[1] = 'Deimos';
	thing[2] = 'Sanford';

	for i=1,2 do
		setLuaSpriteScrollFactor(thing[i], 0.5, 0.5);
		addAnimationByPrefix(thing[i], 'Boop', thing[i] .. ' Boop', 24, false);
		addAnimationByPrefix(thing[i], 'Appear', thing[i] .. ' Appear', 24, false);
		addAnimationByPrefix(thing[i], 'Shoot', thing[i] .. ' Shoot', 24, false);
		scaleObject(thing[i], 1.1, 1.1, false);
		-- setProperty(thing[i] .. '.visible', false);
		setProperty(thing[i] .. '.alpha', 0.00001);
	end
	thing = nil;
	
	makeAnimatedLuaSprite('Lazer','LazerDot', 525, -10);
	addAnimationByPrefix('Lazer', 'Flash', 'LazerDot Flash', 24, false);
	addAnimationByPrefix('Lazer', 'Boop', 'LazerDot Boop', 24, false);
	scaleObject('Lazer', 1.5, 1.5, true);
	setProperty('Lazer.visible', false);

	makeAnimatedLuaSprite('Speakers','speakers', 205, 250);
	addAnimationByPrefix('Speakers', 'Boop', 'speakers', 24, false);

	makeAnimatedLuaSprite('gf-hot','GFHotdog', 1530, 200);
	addAnimationByIndices('gf-hot', 'Boop-left', 'GFStandingWithHotDog', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14', 24);
	addAnimationByIndices('gf-hot', 'Boop-right', 'GFStandingWithHotDog', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29', 24);
	addAnimationByPrefix('gf-hot', 'Walk', 'GFStandingWithHotDogWalk', 24, true);
	-- setProperty('gf-hot.visible', false);
	setProperty('gf-hot.alpha', 0.00001);
	
	makeAnimatedLuaSprite('climber1','Climbers', 330, -147);
	makeAnimatedLuaSprite('climber2','Climbers', -300, 180);
	makeAnimatedLuaSprite('climber3','Climbers', 1170, 208);
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
	end
	thing = nil;

	-- I set the alpha to 0.00001 (not 0 and not .visible = false), 
	-- and because of that the game engine thinks it needs to load the
	-- sprites into the stage, although you can't actually see
	-- them. Like that, I can load sprites early and avoid lag.

	-- I also recommend avoiding the need to down scale sprites through
	-- code. Make the sprites smaller before loading them, and like that
	-- you won't have to load bigger sprites than you actually need to.

			-- offsets --
	-- Deimos
	addOffset('Deimos', 'Appear', 89, 488);
	addOffset('Deimos', 'Shoot', 5, 0);

	-- Sanford
	addOffset('Sanford', 'Appear', -3, 420);
	addOffset('Sanford', 'Shoot', 218, 10);

	-- Lazer
	addOffset('Lazer', 'Flash', 0, -20);

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

	-- we add tricky to the girlfriend group
	addCharacterToList('tricky', 'gf');
end

















----------------------------------------------------------------------------------------------------------------------
		-- Camera Shit --
----------------------------------------------------------------------------------------------------------------------
dadCamPos = {419.5, 398.5};
bfCamPos = {705.5, 398.5};

function onMoveCamera(focus)
	if focus == 'dad' then
		-- we override the character's camera positions
		setProperty('camFollow.x', dadCamPos[1]);
		setProperty('camFollow.y', dadCamPos[2]);
	end
	if focus == 'boyfriend' then
		-- we override the character's camera positions
		setProperty('camFollow.x', bfCamPos[1]);
		setProperty('camFollow.y', bfCamPos[2]);
	end
end

----------------------------------------------------------------------------------------------------------------------
    	-- Events --
----------------------------------------------------------------------------------------------------------------------

-- used to make Deimos stop his idle animation
stopDeimos = true;
-- used to make Sanford stop his idle animation
stopSanford = true;
-- used to make hotdog gf stop her idle animation
stopHotDogGF = true;
-- used to make the lazer stop his idle animation
local stopLazer = true;
-- used to tell each climber what skin it should use (1 = grunt, 2 = agent, 3 = engineer)
local climberSkin = {1,2,3; n=3};-- (climberSkin[1] = middle, climberSkin[2] = left, climberSkin[3] = right)

-- used to tell each climber if he should appear or not (0 = appear, 1 = don't appear)
local appearList = {1,0,0; n=3};-- (appearList[1] = middle, appearList[2] = left, appearList[3] = right)

function onEvent(name, value1, value2)
	if name == 'Heli Appear' then
		-- we change the helicopter's x velocity
		setProperty('helicopter.velocity.x', 430);
	elseif name == 'Deimos&Sanford Appear' then
		-- we make the camera positions higher
		dadCamPos[2] = dadCamPos[2] - 80;
		bfCamPos[2] = bfCamPos[2] - 80;
		-- setProperty('Deimos.visible', true);
		setProperty('Deimos.alpha', 1);
		-- setProperty('Sanford.visible', true);
		setProperty('Sanford.alpha', 1);
		playAnim('Deimos', 'Appear', false);
		playAnim('Sanford', 'Appear', false);
		-- we stop their idle
		stopDeimos = true; 
		stopSanford = true;
		runTimer('HandsUpTimer', 0.3, 1);
	elseif name == 'Play Animation' then
		if value2 == 'gf' then
			if value1 == 'Enter' then
				-- we make the lazer invisible, but not for long..
				-- setProperty('Lazer.visible', false);
				setProperty('Lazer.alpha', 0.00001);

				-- setProperty('She friking flyy.visible', true);
				setProperty('She friking flyy.alpha', 1);
				setProperty('She friking flyy.velocity.x', 15000);
				-- She friking flyy!!
			end
			if value1 == 'Turn' then
				-- we set blood position
				triggerEvent('Set Blood Effect Pos', 220, -140);
				-- now the Lazer will be invisible forever. HAHAHAAH
				setProperty('Lazer.visible', false);
				stopLazer = true;
				-- we make the character stunned to prevent him from playing the idle animation
				setProperty('gf.stunned', true);
				-- we set specialAnim to false to prevent him from playing the idle animation anyway
				setProperty('gf.specialAnim', false);

				-- I see a lot of people that make separate sprites for character animations that
				-- need to not convert to the idle animation. This can cause lag problems if not done
				-- right (without the alpha = 0.00001 thing), uses more RAM then It needs to 
				-- (because of all the FlxSprite object that are created) and makes your code unorganized.
				-- There are also people that make separate characters, which is better performance wise,
				-- but worse RAM wise. The code above reaches the same goal, but without making any extra 
				-- sprites or characters. just one character for all of the animations.
			end
			if value1 == 'Fall' then
				-- we play the blood animation
				triggerEvent('Add Blood Effect', '', '');
				-- he goes up
				doTweenY('ClownGoUp', 'gf', -550, 0.3, 'sineOut');
			end
		end
	elseif name == 'HotDogGF Appears' then
		-- we stop her idle animation from playing
		stopHotDogGF = true;
		-- we make her visible
		-- setProperty('gf-hot.visible', true);
		setProperty('gf-hot.alpha', 1);
		-- we play her walking animation
		playAnim('gf-hot', 'Walk', false);
		-- we do a x position tween
		doTweenX('HotGFWalksIn', 'gf-hot', getProperty('gf-hot.x') - HotGFMovementAmount, 0.8, 'linear');
	elseif name == 'They climb and get shot at' then
		math.randomseed(os.time()); -- os.time is back baby!!!!
		for i=1, #climberSkin do  -- #climberSkin = #appearList = 3

			-- we make them appear at a random
			-- amount and order with a random look.
			climberSkin[i] = math.random(1,3);
			appearList[i] = math.random(0,1);

			-- if the climber appears
			if appearList[i] == 1 then
				-- do the climb animation
				playAnim('climber' .. i, 'Climb' .. climberSkin[i], true);
				-- be visible
				-- setProperty('climber' .. i .. '.visible', true);
				setProperty('climber' .. i .. '.alpha', 1);
			end
		end
		-- if any climber appears
		if arraySum(appearList) ~= 0 then
			-- run the shoot timer (code that handles
			-- the animation of the climbers being shot
			-- will run in the end of the timer)
			runTimer('ShootTimer', 0.55, 1);
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
		--Tween Completions--
--------------------------------------------------------------------------------------------------------------------
function onTweenCompleted(tag)
	if tag == 'ClownGoUp' then
		-- he goes behind the ground
		setObjectOrder('gfGroup', getObjectOrder('Ground'));
		-- and now he falls down. bye bye!
		doTweenY('ClownGoDown', 'gf', 1000, 0.7, 'sineIn');
	elseif tag == 'HotGFWalksIn' then
		-- now that the tween ended, she needs to stop and do
		-- the idle animation, so we need to stop stoping her
		-- from doing the idle animation.
		stopHotDogGF = false;
	end
end

--------------------------------------------------------------------------------------------------------------------
		--Timer Completions--
--------------------------------------------------------------------------------------------------------------------
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'ShootTimer' then
		-- play death sound
		playSound('death sound', 0.5);
		-- if the middle or right climber appears
		if appearList[1] == 1 or appearList[3] == 1 then
			-- make Deimos shoot
			playAnim('Deimos', 'Shoot', false);
			-- stop his idle animation
			stopDeimos = true;
		end
		-- if the middle or left climber appears
		if appearList[1] == 1 or appearList[2] == 1 then
			-- make Sanford shoot
			playAnim('Sanford', 'Shoot', false);
			-- stop his idle animation
			stopSanford = true;
		end
		for i=1, #climberSkin do -- #climberSkin = #appearList = 3
			-- if the climber appears
			if appearList[i] == 1 then
				-- make him play the shot animation
				playAnim('climber' .. i, 'Shoot' .. climberSkin[i], true);
			end
		end
	elseif tag == 'HandsUpTimer' then
		-- we play the hand raise animation
		triggerEvent('Play Animation', 'Raise', 'gf');
		-- we change the idle animation
		triggerEvent('Alt Idle Animation', 'gf', '-alt');
		-- we make the lazer visible
		setProperty('Lazer.visible', true);
		-- we make the lazer play the flash animation
		playAnim('Lazer', 'Flash', false);
		stopLazer = true;
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
	-- we make the lazer invisible when tricky hits a note
end

function onBeatHit()
-----------         -----------
  --Lazer Visibility Sequel--
-----------  		-----------
	-- when tricky is back to his idle animation, we make the lazer visible again
	if (getProperty('gf.animation.curAnim.name') == 'danceLeft' or 
	getProperty('gf.animation.curAnim.name') == 'danceRight') and gfName == 'tricky' then
		-- setProperty('Lazer.visible', true);
		setProperty('Lazer.alpha', 1);
	end
	-- it's on beat hit, because tricky plays his idle animation every beat, so
	-- we don't need to check this on update

---------------------------------------------------
        --Boop Control--
---------------------------------------------------
	-- you know what this does
	if not stopDeimos then
		playAnim('Deimos', 'Boop', true);
	end
	if not stopSanford then
		playAnim('Sanford', 'Boop', true);
	end
	if not stopLazer then
		playAnim('Lazer', 'Boop', true);
		-- we change the lazer's position if tricky 
		-- is on stage
		local lazerX = getProperty('Lazer.x');
		local lazerY = getProperty('Lazer.y');
		if gfName == 'tricky' then
			if lazerX ~= 710 and lazerY ~= 0 then
				setProperty('Lazer.x', 710);
				setProperty('Lazer.y', 0);
			end
		elseif lazerX ~= 525 and lazerY ~= -10 then
			setProperty('Lazer.x', 525);
			setProperty('Lazer.y', -10);
		end 
	end
	if not stopHotDogGF then
		-- we make gf move her head left and right
		if DanceDir then
			playAnim('gf-hot', 'Boop-left', true);
			DanceDir = false;
		else
			playAnim('gf-hot', 'Boop-right', true);
			DanceDir = true;
		end
	end
	-- the speakers always do the idle animation
	playAnim('Speakers', 'Boop', true);
end

---------------------------------------------------
	--Object Visibility and Animation Controls--
---------------------------------------------------
function onUpdate(elapsed)
	for i=1,3 do
		-- if the current animation is a shot animation and it's
		-- finished, then make the sprite invisible
		if getProperty('climber' .. i .. '.animation.curAnim.finished') and 
			getProperty('climber' .. i .. '.animation.curAnim.name'):sub(1, 5) == 'Shoot' then
			-- setProperty('climber' .. i .. '.visible', false);
			setProperty('climber' .. i .. '.alpha', 0.00001);
		end
	end

	-- if the sprite is completely visible and the current animation is finished
	-- then let the sprite play it's idle animation 
	if getProperty('Deimos.alpha') == 1 and getProperty('Deimos.visible') and 
	  getProperty('Deimos.animation.curAnim.finished') and stopDeimos then
		stopDeimos = false;
	end
	if getProperty('Sanford.alpha') == 1 and getProperty('Sanford.visible') and 
	  getProperty('Sanford.animation.curAnim.finished') and stopSanford then
		stopSanford = false;
	end
	if getProperty('Lazer.alpha') == 1 and getProperty('Lazer.visible') and 
	  getProperty('Lazer.animation.curAnim.finished') and stopLazer then
		stopLazer = false;
	end
end