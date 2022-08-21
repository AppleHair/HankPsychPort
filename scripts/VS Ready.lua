-- this script was originally made by Kevin Kuntz
-- and was significantly edited by me,
-- so props to Kevin

function onCreate()
	makeLuaSprite('ready', 'ready', 0, 0);
	makeLuaSprite('readyCL', 'readyCL', 0, 0);
	scaleObject('ready', 0.64, 0.64, true);
	scaleObject('readyCL', 0.64, 0.64, true);
	screenCenter('ready', 'xy');
	screenCenter('readyCL', 'xy');
	addLuaSprite('ready', true);
	addLuaSprite('readyCL', true);
	setObjectCamera('ready', 'hud');
	setObjectCamera('readyCL', 'hud');
end

-- very self-explanatory
local allowCountdown = false;
function onStartCountdown()
	-- we check if countdown is allowed
	if not allowCountdown then
		-- we make the mouse visible
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', true);
		-- we set stunned to true on everyone
		-- to stop them from playing the idle animation
		setProperty('boyfriend.stunned', true);
		setProperty('gf.stunned', true);
		setProperty('dad.stunned', true);

		-- we skip the freeplay arrow alpha tween
		setProperty('skipArrowStartTween', true);

		-- we make the arrows generate early
		runHaxeCode([[
			game.generateStaticArrows(0);
			game.generateStaticArrows(1);
		]]);

		-- we stop the countdown from happening
		return Function_Stop;
	end
	-- we clear everything we did with the arrows
	-- before the game does it again
	runHaxeCode([[
			game.playerStrums.clear();
			game.opponentStrums.clear();
			game.strumLineNotes.clear();
	]]);
	-- we let the countdown happen
	return Function_Continue;
end

-- very self-explanatory
local allowPause = false;
function onCountdownTick(counter)
	if counter == 2 then
		-- we set stunned to false on everyone
		-- to let them play the idle animation
		setProperty('boyfriend.stunned', false);
		setProperty('gf.stunned', false);
		setProperty('dad.stunned', false);
	end
	-- allow pause when song starts
	allowPause = counter == 4;
end


-- true if the mouse is on the ready thing
local MouseOnReady = false;

-- helps me play the scrollMenu sound on update
-- without playing is 60-240 times every second
-- that MouseOnReady is true
local playTheSound = true;

-- represents the x value of the
-- mathematical function that we use
-- to change the scale of the ready thing
local scaleFuncX = 0;

-- determines who much the x value
-- will change every second
local morphSpeed = 2;

function onUpdate(elapsed)
	-- we increase the x value with time but *morphSpeed* times faster
	scaleFuncX = scaleFuncX + elapsed * morphSpeed;
	-- every 10 seconds, the x value will come back to 0
	if scaleFuncX >= morphSpeed * 10 then
		-- I don't want the values to become too big,
		-- because I'm afraid the computer won't be able to handle it.
		scaleFuncX = 0;
	end
	-- f(x) = ((1 - sin(π∙x)) : 2 + 64) : 100
	--  		       ↓
	-- f(x) = ((129 - sin(π∙x)) : 2) : 100
	--  		       ↓
	-- 		ready.scale.x = f(x)
	-- 		ready.scale.y = f(x)
	local theFunc = ((129 - math.sin(math.pi * scaleFuncX)) / 2) / 100;
	setProperty('ready.scale.x', theFunc);
	setProperty('ready.scale.y', theFunc);

	-- we make the readyCL thing slightly bigger than the ready thing.
	-- we need to put this on update, because the ready thing's scale is
	-- being changed on update (code above↑↑↑).
	setProperty('readyCL.scale.x', getProperty('ready.scale.x') + 0.07);
	setProperty('readyCL.scale.y', getProperty('ready.scale.y') + 0.07);

	-- if countdown isn't allowed yet and the player pressed space or enter
	-- or the left mouse button while the cursor was on the ready thing
	if not allowCountdown and (getPropertyFromClass('flixel.FlxG', 'keys.justReleased.SPACE') or 
	  getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ENTER') or (mouseReleased() and MouseOnReady)) then
		-- we allow the countdown
		allowCountdown = true;
		-- we start the countdown
		startCountdown();
		-- we play the clickText sound
		playSound('clickText');
		-- we remove the ready sprites
		removeLuaSprite('ready', true);
		removeLuaSprite('readyCL', true);
		-- we make the mouse invisible
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
	end
	-- we check if the mouse is on the ready thing in the x axis
	local MouseOnReadyX = getMouseX('hud') > getProperty('ready.x') and 
							getMouseX('hud') < getProperty('ready.x') + getProperty('ready.width');
	-- we check if the mouse is on the ready thing in the y axis
	local MouseOnReadyY = getMouseY('hud') > getProperty('ready.y') and 
							getMouseY('hud') < getProperty('ready.y') + getProperty('ready.height');
	-- both of them together means the mouse is on the ready thing
	MouseOnReady =  MouseOnReadyX and MouseOnReadyY;

	-- we make ready visible and readyCL invisible
	setProperty('ready.visible', true);
	setProperty('readyCL.visible', false);
	-- we check if the mouse is on the ready thing
	if MouseOnReady then
		-- we make readyCL visible and ready invisible
		setProperty('ready.visible', false);
		setProperty('readyCL.visible', true);
		-- we check if we need to play the sound
		if playTheSound then
			-- we play the scrollMenu sound
			playSound('scrollMenu');
			-- we set playTheSound to false
			playTheSound = false;
		end
	else
		-- if the mouse is not on the ready thing,
		-- we make playTheSound true again.
		playTheSound = true;
	end
end
function onUpdatePost(elapsed)
	-- if the player pressed escape and the pause isn't allowed yet
	if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and not allowPause then
		-- we prevent a game crash that is being caused by 3 achievements that are being 
		-- unlocked in the same time. we prevent these achievements from being achieved.
		setProperty('boyfriendIdled', true);
		setProperty('keysPressed', {true,true,true});
		setProperty('ratingPercent', 0.41);
		-- we end the song
		endSong();
	end
end

function onPause()
	-- we check if pause is allowed
	if allowPause then
		-- we let the pause happen
		return Function_Continue;
	end
	-- we stop the pause from happening
	return Function_Stop;
end


