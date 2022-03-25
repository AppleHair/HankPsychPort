local HotGFMovementAmount = 350; --Start X = 1530--    --Future X: 1180--    --Difference: 350--
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
	setProperty('Speakers.visible', true);
	precacheImage('dumb_speakers');

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
	scaleObject('gf-hot', 1, 1);
	precacheImage('GFHotdog');

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
	addLuaSprite('gf-hot', false);
	addLuaSprite('She friking flyy',true);
	addLuaSprite('HotdogStation',true);
	addLuaSprite('Rock',true);
	addLuaSprite('Lazer',true);
	addLuaSprite('Static', false);
end

function onCountdownTick(counter)
	if (counter == 0) then
		setProperty('helicopter.velocity.x', 300);
	end
end

     --Animations and events--

local StopDMiandSAN = false;
local StopLazer = false;
local clownAndLazer = false;
local WalkingHotDogGF = false;

function onEvent(name, value1, value2)
	if name == 'Deimos&Sanford Appear' then
		StopDMiandSAN = true;
		luaSpritePlayAnimation('Deimos', 'Appear', false);
		setProperty('Deimos.y', -670);
		setProperty('Deimos.x', -490);
		setProperty('Deimos.visible', true);
		luaSpritePlayAnimation('Sanford', 'Appear', false);
		setProperty('Sanford.y', -610);
		setProperty('Sanford.x', 1225);
		setProperty('Sanford.visible', true);
		runTimer('AppearTimer', 0.3, 1);
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
		luaSpritePlayAnimation('gf-hot', 'Walk', false);
		doTweenX('HotGFWalksIn', 'gf-hot', getProperty('gf-hot.x') - HotGFMovementAmount, 0.8, 'linear');
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
	if tag == 'AppearTimer' then
		StopDMiandSAN = false;
		triggerEvent('Play Animation', 'Raise', 'gf');
		triggerEvent('Alt Idle Animation', 'gf', '-alt');
		luaSpritePlayAnimation('Lazer', 'Flash', false);
		setProperty('Lazer.y', -19);
		setProperty('Lazer.x', 494);
		setProperty('Lazer.visible', true);
		StopLazer = true;
		runTimer('FlashTimer', 0.5, 1);
	end
	if tag == 'FlashTimer' then
		StopLazer = false;
	end
end

      --Boops--

function onBeatHit()
	if (getProperty('gf.animation.curAnim.name') == 'danceLeft' or getProperty('gf.animation.curAnim.name') == 'danceRight') and clownAndLazer then
		setProperty('Lazer.visible', true);
	end
	if not StopDMiandSAN then
		luaSpritePlayAnimation('Deimos', 'Boop', true);
		setProperty('Deimos.y', -230);
		setProperty('Deimos.x', -405);
		luaSpritePlayAnimation('Sanford', 'Boop', true);
		setProperty('Sanford.y', -225);
		setProperty('Sanford.x', 1225);
	end
	if not StopLazer then
		luaSpritePlayAnimation('Lazer', 'Boop', true);
		if clownAndLazer then
			setProperty('Lazer.y', 0);
			setProperty('Lazer.x', 680);
		else
			setProperty('Lazer.y', -30);
			setProperty('Lazer.x', 490);
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