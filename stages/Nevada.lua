local HotGFMovementAmount = 350; 
local DanceDir = false; -- true = left  false = right

function onCreate()
    --static--
	
	makeLuaSprite('HotdogStation','NevadaHotdog', -910, -340);
	setLuaSpriteScrollFactor('HotdogStation', 2.2, 1.7);
	scaleObject('HotdogStation', 1.2, 1.2);

	makeLuaSprite('Rock','The Rock', -1025, -470);
	setLuaSpriteScrollFactor('Rock', 2.2, 1.7);
	scaleObject('Rock', 1.32, 1.32);
	
	makeLuaSprite('Ground','NevadaGround', -795, -595);
	scaleObject('Ground', 1.45, 1.45);
	
	makeLuaSprite('RightDwayne','NevadaRightDwayne', -550, -450);
	setLuaSpriteScrollFactor('RightDwayne', 0.5, 0.6);
	scaleObject('RightDwayne', 1.45, 1.45);

	makeLuaSprite('LeftDwayne','NevadaLeftDwayne', -550, -450);
	setLuaSpriteScrollFactor('LeftDwayne', 0.5, 0.6);
	scaleObject('LeftDwayne', 1.45, 1.45);
	
	makeLuaSprite('Sky','NevadaSky', -366, -425);
	setLuaSpriteScrollFactor('Sky', 0.2, 0.1);
	scaleObject('Sky', 1.16, 1.16);
	
	--animated--
	
	makeAnimatedLuaSprite('helicopter', 'helicopter', -3000, -270);
	addAnimationByPrefix('helicopter', 'Fly', 'Fly', 24, true);
	setScrollFactor('helicopter', 0.4, 0.3);
	scaleObject('helicopter', 1.2, 1.2);
	
	
	makeAnimatedLuaSprite('Deimos','Deimos', -405, -230);
	setLuaSpriteScrollFactor('Deimos', 0.5, 0.6);
	addAnimationByPrefix('Deimos', 'Boop', 'Deimos Boop', 24, false);
	addAnimationByPrefix('Deimos', 'Appear', 'Deimos appear', 24, false);
	addAnimationByPrefix('Deimos', 'Shoot', 'Deimos Shoot', 24, false);
	setProperty('Deimos.visible', false);
	precacheImage('Deimos');
	
	
	makeAnimatedLuaSprite('Sanford','Sanford', 1230, -225);
	setLuaSpriteScrollFactor('Sanford', 0.5, 0.6);
	addAnimationByPrefix('Sanford', 'Boop', 'Sanford Boop', 24, false);
	addAnimationByPrefix('Sanford', 'Appear', 'Sanford Appear', 24, false);
	addAnimationByPrefix('Sanford', 'Shoot', 'Sanford Shoot', 24, false);
	setProperty('Sanford.visible', false);
	precacheImage('Sanford');
	
	makeAnimatedLuaSprite('Lazer','LazerDot', 500, -60);
	addAnimationByPrefix('Lazer', 'Flash', 'LazerDot Flash', 24, false);
	addAnimationByPrefix('Lazer', 'Boop', 'LazerDot Boop', 24, false);
	scaleObject('Lazer', 1.5, 1.5);
	setProperty('Lazer.visible', false);
	precacheImage('LazerDot');

	makeAnimatedLuaSprite('Speakers','dumb_speakers', 205, 240);
	addAnimationByPrefix('Speakers', 'Boop', 'speakers', 24, false);

	makeAnimatedLuaSprite('She friking flyy','GF_go_bye_bye', 170, -80);
	addAnimationByPrefix('She friking flyy', 'AAA', 'She covered her self in oil', 24, true);
	setProperty('She friking flyy.visible', false);
	precacheImage('GF_go_bye_bye');

	makeAnimatedLuaSprite('cutsceneClown','TrickyCutsceneClownAssets', 300, -240);
	addAnimationByPrefix('cutsceneClown', 'Turn', 'trickyturning', 24, false);
	addAnimationByPrefix('cutsceneClown', 'Fall', 'tikygetsshot', 24, true);
	scaleObject('cutsceneClown', 0.8, 0.8);
	setProperty('cutsceneClown.visible', false);
	precacheImage('TrickyCutsceneClown');

	makeAnimatedLuaSprite('gf-hot','GFHotdog', 1520, 200);
	addAnimationByIndices('gf-hot', 'Boop-left', 'GFStandingWithHotDog', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14', 24);
	addAnimationByIndices('gf-hot', 'Boop-right', 'GFStandingWithHotDog', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29', 24);
	addAnimationByPrefix('gf-hot', 'Walk', 'GFStandingWithHotDogWalk', 24, true);
	setProperty('gf-hot.visible', false);
	scaleObject('gf-hot', 1, 1);
	precacheImage('GFHotdog');

	makeAnimatedLuaSprite('climber1','Climbers', 330, -157);
	addAnimationByIndices('climber1', 'Climb1', 'gruntclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber1', 'Shoot1', 'gruntclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	addAnimationByIndices('climber1', 'Climb2', 'agentclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber1', 'Shoot2', 'agentclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	addAnimationByIndices('climber1', 'Climb3', 'engclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber1', 'Shoot3', 'engclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	setProperty('climber1.visible', false);
	scaleObject('climber1', 0.85, 0.85);

	makeAnimatedLuaSprite('climber2','Climbers', -300, 183);
	addAnimationByIndices('climber2', 'Climb1', 'gruntclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber2', 'Shoot1', 'gruntclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	addAnimationByIndices('climber2', 'Climb2', 'agentclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber2', 'Shoot2', 'agentclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	addAnimationByIndices('climber2', 'Climb3', 'engclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber2', 'Shoot3', 'engclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	setProperty('climber2.angle', -3.5);
	setProperty('climber2.visible', false);
	scaleObject('climber2', 0.85, 0.85);

	makeAnimatedLuaSprite('climber3','Climbers', 1170, 210);
	addAnimationByIndices('climber3', 'Climb1', 'gruntclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber3', 'Shoot1', 'gruntclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	addAnimationByIndices('climber3', 'Climb2', 'agentclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber3', 'Shoot2', 'agentclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	addAnimationByIndices('climber3', 'Climb3', 'engclimbanddie', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15', 24);
	addAnimationByIndices('climber3', 'Shoot3', 'engclimbanddie', '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28', 24);
	setProperty('climber3.angle', 5);
	setProperty('climber3.visible', false);
	scaleObject('climber3', 0.85, 0.85);

	precacheImage('Climbers');

	makeAnimatedLuaSprite('Static','TrickyStatic', 0, 0);
	addAnimationByPrefix('Static', 'Stat', 'Stat', 24, true);
	setGraphicSize('Static',1280,720);
	setObjectCamera('Static','camHud');
	setProperty('Static.visible', false);
	precacheImage('TrickyStatic');
	
	--layers--
	
	addLuaSprite('Sky',false);
	addLuaSprite('helicopter',false);
	addLuaSprite('LeftDwayne',false);
	addLuaSprite('RightDwayne',false);
	addLuaSprite('Deimos',false);
	addLuaSprite('Sanford',false);
	addLuaSprite('Ground',false);
	addLuaSprite('Speakers',false);
	addLuaSprite('cutsceneClown',false);
	addLuaSprite('climber1',false);
	addLuaSprite('climber2',false);
	addLuaSprite('climber3',false);
	addLuaSprite('gf-hot', false);
	addLuaSprite('She friking flyy',true);
	addLuaSprite('HotdogStation',true);
	addLuaSprite('Rock',true);
	addLuaSprite('Lazer',true);
	addLuaSprite('Static', false);
end

-- function onCreatePost()
-- 	setProperty('gf.visible', false);
-- end

--[[
used to make a object/lua sprite play an animation with
an different x and y position to make it fit.

(warning: this doesn't work like it does with charater position.
 It's not In relation to the center of the object. it's literally a position on the stage)
]]
function PlayOffsetedAnim(objName, animName, x, y, forced) 
	objectPlayAnimation(objName, animName, forced);
	setProperty(objName ..'.x', x);
	setProperty(objName ..'.y', y);
end

function ArraySum(arr)
	local sum = 0;
	for i=1,table.getn(arr) do
		sum = sum + arr[i];
	end
	return sum;
end

function onCountdownTick(counter)
	if (counter == 0) then
		setProperty('helicopter.velocity.x', 300); -- helicopter helicopter
	end
end

     --Animations and events--

local StopDMiandSAN = false; -- used to make Deimos and sanford stop their idle animation
local StopLazer = false; -- used to make the lazer stop his idle animation
local clownAndLazer = false; -- used to check if tricky entered the stage. helps for executing clown-lazer behavior
local WalkingHotDogGF = false; -- used for checking if gf is walking to stop her idle animation
local whatTheyDo = {1,2,3; n=3}; -- used to tell each climber what to be (1 = grunt, 2 = agent, 3 = engineer)
						  -- (whatTheyDo[1] = middle, whatTheyDo[2] = left, whatTheyDo[3] = right)
local doYouEvenDo = {1,0,0; n=3}

function onEvent(name, value1, value2)
	if name == 'Deimos&Sanford Appear' then
		StopDMiandSAN = true;
		PlayOffsetedAnim('Deimos', 'Appear', -490, -670, false);
		setProperty('Deimos.visible', true);
		PlayOffsetedAnim('Sanford', 'Appear', 1225, -610, false);
		setProperty('Sanford.visible', true);
		runTimer('HandsUpTimer', 0.3, 1);
	end
	if name == 'Tricky Kicks GF' then
		setProperty('Lazer.visible', false);
		clownAndLazer = true;
	end
	if name == 'Tricky Lookin' then
		clownAndLazer = false;
		setProperty('Lazer.visible', false);
		setProperty('gf.visible', false);
		setProperty('cutsceneClown.visible', true);
		luaSpritePlayAnimation('cutsceneClown', 'Turn', true);
	end
	if name == 'Tricky Fallin' then
		luaSpritePlayAnimation('cutsceneClown', 'Fall', true);
		setProperty('cutsceneClown.y', -490);
		doTweenY('ClownGoUp', 'cutsceneClown', -1000, 0.4, 'sineInOut');
	end

	if name == 'HotDogGF Appears' then
		WalkingHotDogGF = true;
		setProperty('gf-hot.visible', true);
		luaSpritePlayAnimation('gf-hot', 'Walk', false);
		doTweenX('HotGFWalksIn', 'gf-hot', getProperty('gf-hot.x') - HotGFMovementAmount, 0.8, 'linear');
	end
	
	if name == 'They climb and get shot at' then
		math.randomseed(curStep + score); -- I'm a fricking genius
		for i=1,table.getn(whatTheyDo) do
			whatTheyDo[i] = math.random(1,3);
			doYouEvenDo[i] = math.random(0,1);
			if doYouEvenDo[i] == 1 then
				objectPlayAnimation('climber' .. i, 'Climb' .. whatTheyDo[i], true);
				setProperty('climber' .. i .. '.visible', true);
			end
		end
		if not (ArraySum(doYouEvenDo) == 0) then
			runTimer('ShootTimer', 0.55, 1);
		end
	end
end

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

     --The lazer and the clown--

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'GF Sing' and clownAndLazer then
		setProperty('Lazer.visible', false);
	end
end

     --Timers--

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'HandsUpTimer' then
		triggerEvent('Play Animation', 'Raise', 'gf');
		triggerEvent('Alt Idle Animation', 'gf', '-alt');
		PlayOffsetedAnim('Lazer', 'Flash', 504, -24, false);
		setProperty('Lazer.visible', true);
		StopLazer = true;
	end
	if tag == 'ShootTimer' then
		playSound('death sound', 0.4);
		StopDMiandSAN = true;
		PlayOffsetedAnim('Deimos', 'Shoot', -407, -232, false);
		PlayOffsetedAnim('Sanford', 'Shoot', 1025, -237, false);
		for i=1,table.getn(whatTheyDo) do
			if doYouEvenDo[i] == 1 then
				objectPlayAnimation('climber' .. i, 'Shoot' .. whatTheyDo[i], true);
				setProperty('climber' .. i .. '.visible', true);
			end
		end
	end
end

      --Boops--

function onBeatHit()
	if (getProperty('gf.animation.curAnim.name') == 'danceLeft' or getProperty('gf.animation.curAnim.name') == 'danceRight') and clownAndLazer then
		setProperty('Lazer.visible', true);
	end
	if not StopDMiandSAN then
		PlayOffsetedAnim('Deimos', 'Boop', -405, -230, true);
		PlayOffsetedAnim('Sanford', 'Boop', 1225, -225, true);
	end
	if not StopLazer then
		luaSpritePlayAnimation('Lazer', 'Boop', true);
		if clownAndLazer then
			setProperty('Lazer.y', 0);
			setProperty('Lazer.x', 680);
		else
			setProperty('Lazer.y', -35);
			setProperty('Lazer.x', 500);
		end
	end
	if not WalkingHotDogGF then
		if DanceDir then
			luaSpritePlayAnimation('gf-hot', 'Boop-left', true);
			DanceDir = false;
		else
			luaSpritePlayAnimation('gf-hot', 'Boop-right', true);
			DanceDir = true;
		end
	end
	luaSpritePlayAnimation('Speakers', 'Boop', true);
end

function onUpdate(elapsed)
	for i=1,table.getn(whatTheyDo) do
		if getProperty('climber' .. i .. '.animation.curAnim.finished') then
			setProperty('climber' .. i .. '.visible', false);
		end
	end
	if getProperty('Deimos.animation.curAnim.finished') and getProperty('Sanford.animation.curAnim.finished') and StopDMiandSAN then
		StopDMiandSAN = false;
	end
	if getProperty('Lazer.animation.curAnim.finished') and StopLazer then
		StopLazer = false;
	end
end