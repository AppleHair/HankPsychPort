function onCreate()
	makeLuaSprite('ready', 'ready', 0, 0)
	makeLuaSprite('readyCL', 'readyCL', 0, 0)
	scaleObject('ready', 0.64, 0.64, true)
	scaleObject('readyCL', 0.64, 0.64, true)
	screenCenter('ready', 'xy')
	screenCenter('readyCL', 'xy')
	addLuaSprite('ready', true)
	addLuaSprite('readyCL', true)
	setObjectCamera('ready', 'hud')
	setObjectCamera('readyCL', 'hud')
	doTweenX('RXS0', 'ready.scale', 0.65, 0.5, 'quadInOut')
	doTweenY('RYS0', 'ready.scale', 0.65, 0.5, 'quadInOut')
end

local allowCountdown = false
function onStartCountdown()
	if not allowCountdown then
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', true);
		setProperty('boyfriend.stunned', true)
		setProperty('gf.stunned', true)
		setProperty('dad.stunned', true)
		return Function_Stop
	end
	return Function_Continue
end

local allowPause = false
function onCountdownTick(counter)
	if counter == 2 then
		setProperty('boyfriend.stunned', false)
		setProperty('gf.stunned', false)
		setProperty('dad.stunned', false)
	end
	allowPause = counter == 4
end

local MouseOnReady = false
function onUpdate(elapsed)
	setProperty('readyCL.scale.x', getProperty('ready.scale.x') + 0.1)
	setProperty('readyCL.scale.y', getProperty('ready.scale.y') + 0.1)
	if not allowCountdown and (getPropertyFromClass('flixel.FlxG', 'keys.justReleased.SPACE') or getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ENTER') or (mouseReleased('funny') and MouseOnReady)) then
		allowCountdown = true
		startCountdown()
		playSound('clickText')
		removeLuaSprite('ready', true)
		removeLuaSprite('readyCL', true)
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
	end
	local MouseOnReadyX = getMouseX('hud') > getProperty('ready.x') and getMouseX('hud') < getProperty('ready.x') + getProperty('ready.width')
	local MouseOnReadyY = getMouseY('hud') > getProperty('ready.y') and getMouseY('hud') < getProperty('ready.y') + getProperty('ready.height')
	MouseOnReady =  MouseOnReadyX and MouseOnReadyY
	setProperty('ready.visible', true)
	setProperty('readyCL.visible', false)
	if MouseOnReady then
		setProperty('ready.visible', false)
		setProperty('readyCL.visible', true)
	end
end
function onUpdatePost(elapsed)
	if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and not allowPause then
		-- The FIX-- The FIX
		setProperty('boyfriendIdled', true);-- The FIX-- The FLX-- The FIX-- The FLX-- The FIX-
		setProperty('keysPressed', {true,true,true,true,true,true,true,true,true,true,true,true});-- The FIX-- The FIX
		setProperty('ratingPercent', 0.41);-- The FLX
		-- The FIX-- The FIX--- The FIX-- The FIX
		endSong()
	end
end

function onTweenCompleted(tag)
	if tag == 'RXS0' then
		doTweenX('RXS2', 'ready.scale', 0.64, 0.5, 'quadInOut')
		doTweenY('RYS2', 'ready.scale', 0.64, 0.5, 'quadInOut')
	elseif tag == 'RXS2' then
		doTweenX('RXS0', 'ready.scale', 0.65, 0.5, 'quadInOut')
		doTweenY('RYS0', 'ready.scale', 0.65, 0.5, 'quadInOut')
	end
end

function onPause()
	if not allowPause then
		return Function_Stop
	end
	return Function_Continue
end


