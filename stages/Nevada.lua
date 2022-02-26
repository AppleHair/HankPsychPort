function onCreate()
    --static--
	
	makeLuaSprite('HotdogStation','NevadaHotdog', -980, -465);
	setLuaSpriteScrollFactor('HotdogStation', 2.2, 1.7);
	scaleObject('HotdogStation', 1.24, 1.24);
	
	makeLuaSprite('Ground','NevadaGround', -785, -640);
	scaleObject('Ground', 1.445, 1.445);
	
	makeLuaSprite('Dwaynes','NevadaDwaynes', -495, -455);
	setLuaSpriteScrollFactor('Dwaynes', 0.5, 0.6);
	scaleObject('Dwaynes', 1.41, 1.41);
	
	makeLuaSprite('Sky','NevadaSky', -345, -410);
	setLuaSpriteScrollFactor('Sky', 0.2, 0.1);
	scaleObject('Sky', 1.15, 1.15);
	
	--animated--
	
	makeAnimatedLuaSprite('helicopter', 'helicopter', -3000, -280);
	addAnimationByPrefix('helicopter', 'Fly', 'Fly', 24, true);
	setScrollFactor('helicopter', 0.4, 0.3);
	scaleObject('helicopter', 1.2, 1.2);
	setProperty('helicopter.velocity.x', 300);
	
	
	makeAnimatedLuaSprite('Deimos','Deimos', -390, -230);
	setLuaSpriteScrollFactor('Deimos', 0.5, 0.6);
	addAnimationByPrefix('Deimos', 'Appear', 'Deimos appear', 24, false);
	addAnimationByPrefix('Deimos', 'Shoot', 'Deimos Shoot', 24, false);
	addAnimationByPrefix('Deimos', 'Boop', 'Deimos Boop', 24, false);
	setProperty('Deimos.visible', false);
	precacheImage('Deimos');
	
	
	makeAnimatedLuaSprite('Sanford','Sanford', 1215, -245);
	setLuaSpriteScrollFactor('Sanford', 0.5, 0.6);
	addAnimationByPrefix('Sanford', 'Appear', 'Sanford Appear', 24, false);
	addAnimationByPrefix('Sanford', 'Shoot', 'Sanford Shoot', 24, false);
	addAnimationByPrefix('Sanford', 'Boop', 'Sanford Boop', 24, false);
	setProperty('Sanford.visible', false);
	precacheImage('Sanford');
	
	makeAnimatedLuaSprite('Lazer','LazerDot', 500, -70);
	addAnimationByPrefix('Lazer', 'Flash', 'LazerDot Flash', 24, false);
	addAnimationByPrefix('Lazer', 'Boop', 'LazerDot Boop', 24, false);
	scaleObject('Lazer', 1.5, 1.5);
	setProperty('Lazer.visible', false);
	precacheImage('LazerDot');
	
	--layers--
	
	addLuaSprite('Sky',false);
	addLuaSprite('helicopter',false);
	addLuaSprite('Dwaynes',false);
	addLuaSprite('Deimos',false);
	addLuaSprite('Sanford',false);
	addLuaSprite('Ground',false);
	addLuaSprite('HotdogStation',true);
	addLuaSprite('Lazer',true);
	setProperty('gf.alpha', 0.5);
end

function onUpdate(elapsed)
	-- we need to destroy the heli after it gets out of the scene, so yea..
	if getproperty('helicopter.x') >= 0 then
		removeLuaSprite('helicopter');
	end
end

     --Animations and events--

local Appear = false;
local Flash = false;
-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Deimos&Sanford Appear' then
		Appear = true;
		luaSpritePlayAnimation('Deimos', 'Appear', false);
		setProperty('Deimos.y', -670);
		setProperty('Deimos.x', -475);
		setProperty('Deimos.visible', true);
		luaSpritePlayAnimation('Sanford', 'Appear', false);
		setProperty('Sanford.y', -630);
		setProperty('Sanford.x', 1215);
		setProperty('Sanford.visible', true);
		runTimer('AppearTimer', 0.3, 1);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'AppearTimer' then
		Appear = false;
		triggerEvent('Play Animation', 'Raise', 'gf');
		triggerEvent('Alt Idle Animation', 'gf', '-alt');
		luaSpritePlayAnimation('Lazer', 'Flash', false);
		setProperty('Lazer.y', -59);
		setProperty('Lazer.x', 504);
		setProperty('Lazer.visible', true);
		Flash = true;
		runTimer('FlashTimer', 0.5, 1);
	end
	if tag == 'FlashTimer' then
		Flash = false;
	end
end

      --Boops--

function onBeatHit()
	if not Appear then
		luaSpritePlayAnimation('Deimos', 'Boop', true);
		setProperty('Deimos.y', -230);
		setProperty('Deimos.x', -390);
		luaSpritePlayAnimation('Sanford', 'Boop', true);
		setProperty('Sanford.y', -245);
		setProperty('Sanford.x', 1215);
	end
	if not Flash then
		luaSpritePlayAnimation('Lazer', 'Boop', true);
		setProperty('Lazer.y', -70);
		setProperty('Lazer.x', 500);
	end
end