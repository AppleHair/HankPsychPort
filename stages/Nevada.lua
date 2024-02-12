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
	Checks if a curtain value is
	in a curtain array

	arr - array to check in
	value - value to check
]]
local function isInArray(arr, value)
	for i=1, #arr do
		if arr[i] == value then
			return true;
		end
	end
	return false;
end

--[[
	Splits a string into an array of
	strings according to a curtain delimiter

	s - string to split
	delimiter - delimiter to use
]]
local function split(s, delimiter)
    local result = {};
    -- string.gmatch() explanation: https://www.ibm.com/docs/en/ias?topic=manipulation-stringgmatch-s-pattern#:~:text=Product%20list-,string.gmatch%20(s%2C%20pattern),-Last%20Updated%3A%202021
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

--[[
	returns a trimed version of
	the argument string (removes spaces)

	s - string to trim
]]
local function trim(s)
    -- string.gsub() explanation: https://www.lua.org/pil/20.1.html#:~:text=The-,string.gsub,-function%20has%20three
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
-- string patterns explanation: https://www.lua.org/pil/20.2.html

-- a linear interpolation function
local function lerp(a, b, r)
	return a + (b - a) * r;
end

--[[
	checks if a certain event will be
	called in the current song and returns
	a boolean value accordingly 
	(This function doesn't work with custom events onCreate.
	alternatively, you should use it onCreatePost)

	name - the name of the event
]]
function eventIsCalled(name)
	for i = 0, getProperty('eventNotes.length')-1 do
		if getPropertyFromGroup('eventNotes', i, 'event') == name then
			return true;
		end
	end
	return false;
end

--[[
-------------------------------------------------------------------
			onCreatePost - Table of contents
-------------------------------------------------------------------
	-- Static Lua Sprites - line 113
	-----------------------------------
		HotdogStation - line 115
		Rock - line 119
		Ground - line 123
		RightCliff - line 126
		LeftCliff - line 130
		Sky - line 134

	-- Animated Lua Sprites - line 138
	-----------------------------------
		helicopter - line 140
		Deimos & Sanford - line 145
		Lazer - line 163
		gf-hot - line 169
		Climbers - line 176
		Hellclown - line 197

	-- Tips on sprites in Psych Engine Lua - Line 210
	-----------------------------------
	-- Offsets - line 220
	-----------------------------------
	-- Adding to PlayState - line 235
	-----------------------------------
	-- Precaches - line 257
	-----------------------------------
]]--
function onCreatePost()
			-- Event Related Checks --

	Summon_hellclown = eventIsCalled('Summon Hellclown');

	Climbers_appear = eventIsCalled('Start climbers');

			-- Static Lua Sprites --
	
	makeLuaSprite('HotdogStation','NevadaHotdog', 1010, 441);
	setScrollFactor('HotdogStation', 1.38, 1.35);
	scaleObject('HotdogStation', 1.25, 1.25, true);

	makeLuaSprite('Rock','The Rock', -776, 704);
	setScrollFactor('Rock', 1.38, 1.35);
	scaleObject('Rock', 1.32, 1.32, true);
	
	makeLuaSprite('Ground','NevadaGround', -795, 458);
	scaleObject('Ground', 1.45, 1.45, true);
	
	makeLuaSprite('RightCliff','NevadaRightCliff', 1173, -246);
	setScrollFactor('RightCliff', 0.5, 0.5);
	scaleObject('RightCliff', 1.45, 1.45, true);

	makeLuaSprite('LeftCliff','NevadaLeftCliff', -550, -213);
	setScrollFactor('LeftCliff', 0.5, 0.5);
	scaleObject('LeftCliff', 1.45, 1.45, true);
	
	makeLuaSprite('Sky','NevadaSky', -345, -425);
	setScrollFactor('Sky', 0.1, 0.1);
	scaleObject('Sky', 1.16, 1.16, true);
	
			-- Animated Lua Sprites --
	
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
		setScrollFactor(thing[i], 0.5, 0.5);
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

	makeAnimatedLuaSprite('gf-hot','GFHotdog', 1530, 200);
	addAnimationByIndices('gf-hot', 'Boop-left', 'GFStandingWithHotDog', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14', 24);
	addAnimationByIndices('gf-hot', 'Boop-right', 'GFStandingWithHotDog', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29', 24);
	addAnimationByPrefix('gf-hot', 'Walk', 'GFStandingWithHotDogWalk', 24, true);
	-- setProperty('gf-hot.visible', false);
	setProperty('gf-hot.alpha', 0.00001);
	
	if Climbers_appear then
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
	end

	if Summon_hellclown then
		makeAnimatedLuaSprite('HellClown','HellclownIdle', -100, 535);
		addAnimationByPrefix('HellClown', 'Idle', 'HellClownIdle', 20, true);

		makeAnimatedLuaSprite('HellClownRightHand','HellclownHand', -410, 1335);
		addAnimationByPrefix('HellClownRightHand', 'Idle', 'HellClownHandsIdle', 20, true);

		makeAnimatedLuaSprite('HellClownLeftHand','HellclownHand', 720, 1335);
		addAnimationByIndicesLoop('HellClownLeftHand', 'Idle', 'HellClownHandsIdle', '6,7,8,9,10,11,12,13,1,2,3,4,5', 20);
		setProperty('HellClownLeftHand.flipX', true);
	end


	-- I set the alpha to 0.00001 (not 0 and not .visible = false), 
	-- and because of that the game engine thinks it needs to load the
	-- sprites into the stage, although you can't actually see
	-- them. Like that, I can load sprites early and avoid lag.

	-- I also recommend avoiding the need to down scale sprites through
	-- code. Make the sprites smaller before loading them, and like that
	-- you won't have to load bigger sprites than you actually need to.


			-- Offsets --
	-- Deimos
	addOffset('Deimos', 'Appear', 89, 488);
	addOffset('Deimos', 'Shoot', 5, 0);
	addOffset('Deimos', 'Boop', 0, 0);

	-- Sanford
	addOffset('Sanford', 'Appear', -3, 420);
	addOffset('Sanford', 'Shoot', 218, 10);
	addOffset('Sanford', 'Boop', 0, 0);

	-- Lazer
	addOffset('Lazer', 'Flash', 0, -20);
	addOffset('Lazer', 'Boop', 0, 0);

	  -- Adding to PlayState --
	
	addLuaSprite('Sky',false);
	addLuaSprite('helicopter',false);
	addLuaSprite('LeftCliff',false);
	addLuaSprite('RightCliff',false);
	addLuaSprite('Deimos',false);
	addLuaSprite('Sanford',false);
	if Summon_hellclown then
		addLuaSprite('HellClown', false);
		addLuaSprite('HellClownRightHand', false);
		addLuaSprite('HellClownLeftHand', false);
	end
	addLuaSprite('Ground',false);
	if Climbers_appear then
		for i=1,3 do
			addLuaSprite('climber' .. i,false);
		end
	end
	addLuaSprite('gf-hot', false);
	addLuaSprite('HotdogStation',true);
	addLuaSprite('Rock',true);
	addLuaSprite('Lazer',true);

			-- Precaches --

	precacheSound('death sound');

	if Climbers_appear then
		precacheImage('Climbers');
	end
	precacheImage('GFHotdog');
	precacheImage('LazerDot');
	precacheImage('helicopter');
	precacheImage('Sanford');
	precacheImage('Deimos');
	if Summon_hellclown then
		precacheImage('HellclownIdle');
		precacheImage('HellclownHand');
	end
end

















----------------------------------------------------------------------------------------------------------------------
		-- Camera Shit --
----------------------------------------------------------------------------------------------------------------------
DadCamPos = {419.5, 398.5};
BfCamPos = {705.5, 398.5};

function onMoveCamera(focus)
	if focus == 'dad' then
		-- we override the character's camera positions
		setProperty('camFollow.x', DadCamPos[1]);
		setProperty('camFollow.y', DadCamPos[2]);
	end
	if focus == 'boyfriend' then
		-- we override the character's camera positions
		setProperty('camFollow.x', BfCamPos[1]);
		setProperty('camFollow.y', BfCamPos[2]);
	end
end

----------------------------------------------------------------------------------------------------------------------
    	-- Events --
----------------------------------------------------------------------------------------------------------------------

-- used to make Deimos stop his idle animation
StopDeimos = true;
-- used to make Sanford stop his idle animation
StopSanford = true;
-- used to make hotdog gf stop her idle animation
StopHotDogGF = true;
-- used to make the lazer stop his idle animation
local stopLazer = true;
-- used to make the climbers climb every section hit
local climb = false;
-- used to tell each climber what skin it should use (1 = grunt, 2 = agent, 3 = engineer)
local climberSkin = {1,2,3; n=3};-- (climberSkin[1] = middle, climberSkin[2] = left, climberSkin[3] = right)
-- used to tell each climber if he should appear or not (0 = appear, 1 = don't appear)
local appearList = {1,0,0; n=3};-- (appearList[1] = middle, appearList[2] = left, appearList[3] = right)
-- used to specify indexes of climbers that should never appear (1 = middle, 2 = left, 3 = right)
local neverClimb = {};
-- used to save the intended positions for all of Hellclown's parts
local hellclownTable = 
{
     --Name-     --X-  --Y-
	{'HellClown', -100, -765},
	{'HellClownRightHand', -410, 35},
	{'HellClownLeftHand', 720, 35}
};
-- used to determine if
-- hellclown was just summoned
local hellClownSummoned = false;
-- determines how much time it takes 
-- for hellclown's glow to "fade"
local HellclownGlowFade = 0;
-- Determines how much hellclown
-- should shake when he gets shot
-- (multiplier of 50)
local HellclownShakeIntencity = 1;

function onEvent(name, value1, value2)
	if name == 'Heli Appear' then
		-- we change the helicopter's x velocity
		setProperty('helicopter.velocity.x', 430);
	elseif name == 'Deimos&Sanford Appear' then
		-- we make the camera positions higher
		DadCamPos[2] = DadCamPos[2] - 80;
		BfCamPos[2] = BfCamPos[2] - 80;
		-- setProperty('Deimos.visible', true);
		setProperty('Deimos.alpha', 1);
		-- setProperty('Sanford.visible', true);
		setProperty('Sanford.alpha', 1);
		playAnim('Deimos', 'Appear', false);
		playAnim('Sanford', 'Appear', false);
		-- we stop their idle
		StopDeimos = true; 
		StopSanford = true;
		runTimer('HandsUpTimer', 0.3, 1);
	elseif name == 'Play Animation' then
		if value2 == 'gf' then
			if value1 == 'Enter' then
                -- we make the lazer invisible, but not for long..
                -- setProperty('Lazer.visible', false);
                setProperty('Lazer.alpha', 0.00001);
            end
			if value1 == 'Turn' then
				-- now the Lazer will be invisible forever. HAHAHAAH
                setProperty('Lazer.visible', false);
                stopLazer = true;
			end
			if value1 == 'Fall' then
                -- and now he falls down. bye bye!
                setProperty('gf.velocity.y', -2500);
                setProperty('gf.acceleration.y', 9000);
            end
		end
	elseif name == 'HotDogGF Appears' then
		-- we stop her idle animation from playing
		StopHotDogGF = true;
		-- we make her visible
		-- setProperty('gf-hot.visible', true);
		setProperty('gf-hot.alpha', 1);
		-- we play her walking animation
		playAnim('gf-hot', 'Walk', false);
		-- we make girlfriend go forward
		setProperty('gf-hot.velocity.x', -437.5);
	elseif name == 'Start climbers' then
		-- IDs of climbers we don't want to appear
		neverClimb = split(trim(value1), ',');
		-- we set climb to true and make the
		-- climbers start climbing
		climb = true;
		-- "if we want no one to appear"
		if #neverClimb == 3 then
			neverClimb = {};
			climb = false;
			-- dumbass...
			debugPrint("DUDE, IF YOU DON'T WANT THE CLIMBERS TO APPEAR, THEN JUST DON'T CALL THE EVENT!!");
		end
	elseif name == 'Stop climbers' then
		neverClimb = {};
		-- we set climb to false and make the
		-- climbers stop climbing
		climb = false;
	elseif name == 'Summon Hellclown' then
		if hellClownSummoned then
			DadCamPos[2] = DadCamPos[2] + 65;
			BfCamPos[2] = BfCamPos[2] + 65;
			for i=1, #hellclownTable do
				doTweenY(hellclownTable[i][1] .. 'Tween',hellclownTable[i][1], hellclownTable[i][3] + 1300, 3, 'cubeout');
				setProperty(hellclownTable[i][1]..'.useColorTransform', true);
			end
			doTweenColor('HankHCTween', 'dadGroup', 'ffffff', 3, 'cubeout');
			doTweenColor('BFHCTween', 'boyfriendGroup', 'ffffff', 3, 'cubeout');
			doTweenColor('GFHCTween', 'gfGroup', 'ffffff', 3, 'cubeout');
			doTweenColor('GroundHCTween', 'Ground', 'ffffff', 3, 'cubeout');
			doTweenColor('GFHotdogHCTween', 'gf-hot', (getProperty('gf-hot.alpha') <= 0.00001 and '0x00ffffff' or 'ffffff'), 3, 'cubeout');
			hellClownSummoned = false;
			return;
		end
		DadCamPos[2] = DadCamPos[2] - 65;
		BfCamPos[2] = BfCamPos[2] - 65;
		for i=1, #hellclownTable do
			doTweenY(hellclownTable[i][1] .. 'Tween',hellclownTable[i][1], hellclownTable[i][3], 3, 'cubeout');
		end
		doTweenColor('HankHCTween', 'dadGroup', 'ffc9c9', 3, 'cubeout');
		doTweenColor('BFHCTween', 'boyfriendGroup', 'ffc9c9', 3, 'cubeout');
		doTweenColor('GFHCTween', 'gfGroup', 'ffc9c9', 3, 'cubeout');
		doTweenColor('GroundHCTween', 'Ground', 'ffc9c9', 3, 'cubeout');
		doTweenColor('GFHotdogHCTween', 'gf-hot', (getProperty('gf-hot.alpha') <= 0.00001 and '0x00ffc9c9' or 'ffc9c9'), 3, 'cubeout');
		hellClownSummoned = true;
	elseif name == "Bullet Note Time" and hellClownSummoned then
		-- make Deimos shoot
		playAnim('Deimos', 'Shoot', true);
		-- stop his idle animation
		StopDeimos = true;
		-- make Sanford shoot
		playAnim('Sanford', 'Shoot', true);
		-- stop his idle animation
		StopSanford = true;

		-- make hellclown brighter
		for i=1, #hellclownTable do
			setProperty(hellclownTable[i][1]..'.colorTransform.redMultiplier', 1.5);
			setProperty(hellclownTable[i][1]..'.colorTransform.greenMultiplier', 1.5);
			setProperty(hellclownTable[i][1]..'.colorTransform.blueMultiplier', 1.5);
		end
		-- start the glow fade
		HellclownGlowFade = 0.15;
		-- offset hellclown's middle part
		-- in a random direction and amount
		local shakeAmount = HellclownShakeIntencity * 50;
		local shakeDirection = math.random(0,359);
		math.randomseed(os.time());
		setProperty(hellclownTable[1][1]..'.offset.x', shakeAmount * math.cos(math.rad(shakeDirection)));
		setProperty(hellclownTable[1][1]..'.offset.y', shakeAmount * math.sin(math.rad(shakeDirection)));
	end
end

-- used to delay the climbers' appearance on section hit
-- (this is done to make their appearance more accurate 
-- to the original FNF ONLINE VS. Challenge)
-- (minus - early    plus - late)
local climbDelay = -1;

function onStepHit()
---------------------------------------------------
        --Climbers handler--
---------------------------------------------------
	if (not climb) or ((curStep-climbDelay) % 16 ~= 0) then 
		return;
	end

	math.randomseed(os.time());
	for i=1, #climberSkin do  -- #climberSkin = #appearList = 3
		-- we make them appear at a random
		-- amount and order with a random look.
		climberSkin[i] = math.random(1,3);
		appearList[i] = (isInArray(neverClimb, tostring(i)) and 0 or math.random(0,1));
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
			StopDeimos = true;
		end
		-- if the middle or left climber appears
		if appearList[1] == 1 or appearList[2] == 1 then
			-- make Sanford shoot
			playAnim('Sanford', 'Shoot', false);
			-- stop his idle animation
			StopSanford = true;
		end
		if StopDeimos and StopSanford then
			setProperty('Lazer.alpha', 0.00001);
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
	if getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
		-- setProperty('Lazer.visible', false);
		setProperty('Lazer.alpha', 0.00001);
	end
	-- we make the lazer invisible when tricky hits a note
end

-- true = left  false = right
local hotdogGFDanceDir = false;

function onBeatHit()
-----------         -----------
  --Lazer Visibility Sequel--
-----------  		-----------
	-- when tricky is back to his idle animation, we make the lazer visible again
	if ((getProperty('gf.animation.curAnim.name') == 'danceLeft' or 
		getProperty('gf.animation.curAnim.name') == 'danceRight') and gfName == 'tricky' and
		(not StopDeimos) and (not StopDeimos)) or ((not StopDeimos) and (not StopDeimos) and gfName ~= 'tricky') then
		-- setProperty('Lazer.visible', true);
		setProperty('Lazer.alpha', 1);
	end
	-- it's on beat hit, because tricky, sanford and deimos play their idle animations every beat, so
	-- we don't need to check this on update

---------------------------------------------------
        --Boop handler--
---------------------------------------------------
	-- you know what this does
	if not StopDeimos then
		playAnim('Deimos', 'Boop', true);
	end
	if not StopSanford then
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
	if not StopHotDogGF then
		-- we make gf move her head left and right
		if hotdogGFDanceDir then
			playAnim('gf-hot', 'Boop-left', true);
			hotdogGFDanceDir = false;
		else
			playAnim('gf-hot', 'Boop-right', true);
			hotdogGFDanceDir = true;
		end
	end
end

---------------------------------------------------
	--Sprite and Animation Controls--
---------------------------------------------------

-- true if tricky is behind the ground
local trickyBehindGround = false;
-- true if tricky is gone
local trickyIsGone = false;
-- true if hotdog girlfriend stopped walking
local HotDogGFStoppedWalking = false;
-- tells us if the helicopter is removed
local helicopterRemoved = false;

function onUpdate(elapsed)

	-- Hellclown Offset & Glow Fade Handler
	-----------------------------------------------
	-- if the fade value is greater than 0
    if HellclownGlowFade > 0 then
        -- we decrease the fade value with time
        HellclownGlowFade = HellclownGlowFade - elapsed;
        -- we check if the fade value passed 0
        if HellclownGlowFade <= 0 then
            -- reset hellclown's brightness
			for i=1, #hellclownTable do
				setProperty(hellclownTable[i][1]..'.colorTransform.redMultiplier', 1);
				setProperty(hellclownTable[i][1]..'.colorTransform.greenMultiplier', 1);
				setProperty(hellclownTable[i][1]..'.colorTransform.blueMultiplier', 1);
			end
			-- reset the fade value
            HellclownGlowFade = 0;
        end
    end
	-- we make the hellclown middle part slide into it's main position
	setProperty(hellclownTable[1][1]..'.offset.x',
		lerp(getProperty(hellclownTable[1][1]..'.offset.x'),0,0.2 * (60/(1/elapsed))));
	setProperty(hellclownTable[1][1]..'.offset.y',
		lerp(getProperty(hellclownTable[1][1]..'.offset.y'),0,0.2 * (60/(1/elapsed))));
	
	-- Idle Animation Release handler
	-----------------------------------------------
	-- if the sprite is completely visible and the current animation is finished
	-- then let the sprite play it's idle animation 
	if getProperty('Deimos.alpha') == 1 and getProperty('Deimos.visible') and 
	  getProperty('Deimos.animation.curAnim.finished') and StopDeimos then
		StopDeimos = false;
	end
	if getProperty('Sanford.alpha') == 1 and getProperty('Sanford.visible') and 
	  getProperty('Sanford.animation.curAnim.finished') and StopSanford then
		StopSanford = false;
	end
	if getProperty('Lazer.alpha') == 1 and getProperty('Lazer.visible') and 
	  getProperty('Lazer.animation.curAnim.finished') and stopLazer then
		stopLazer = false;
	end

	
	-- Tricky Fall handler
	-----------------------------------------------
	if getProperty('gf.y') <= -500 and not trickyBehindGround then
		-- he goes behind the ground
		setObjectOrder('gfGroup', getObjectOrder('Ground'));
		trickyBehindGround = true;
	end

	if getProperty('gf.y') >= 1000 and not trickyIsGone then
		setProperty('gf.velocity.y', 0);
		setProperty('gf.acceleration.y', 0);
		setProperty('gf.visible', false);
		trickyIsGone = true;
	end

	
	-- Girlfriend Hotdog handler
	-----------------------------------------------

	if getProperty('gf-hot.x') <= 1180 and not HotDogGFStoppedWalking then
		setProperty('gf-hot.velocity.x', 0);
		-- now that she stopped, she needs to do
		-- the idle animation, so we need to stop stoping her
		-- from doing the idle animation.
		StopHotDogGF = false;
		HotDogGFStoppedWalking = true;
	end

	
	-- The Helicopter Destroyer
	-----------------------------------------------

	-- we make sure that if the helicopter goes off-screen, it gets removed
	if not helicopterRemoved then
		if getProperty('helicopter.x') >= 1700 then
			-- we remove the helicopter
			removeLuaSprite('helicopter', true);
			-- we set this value to true in order
            -- to not check this again
			helicopterRemoved = true;
		end
	end

	-- Climbers Visibility handler
	-----------------------------------------------
	if not Climbers_appear then
		return;
	end
	
	for i=1,3 do
		-- if the current animation is a shot animation and it's
		-- finished, then make the sprite invisible
		if getProperty('climber' .. i .. '.animation.curAnim.finished') and 
			getProperty('climber' .. i .. '.animation.curAnim.name'):sub(1, 5) == 'Shoot' then
			-- setProperty('climber' .. i .. '.visible', false);
			setProperty('climber' .. i .. '.alpha', 0.00001);
		end
	end
end