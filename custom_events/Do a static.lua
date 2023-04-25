-- if you want to use the static texture
-- from madness accelerant, then set this variable to true
local useAccelerantStaticTexture = false;

-- if you want to use static sounds that sound more like the original
-- static sounds from madness combat, then set this variable to true
local useCoolerStaticSounds = false;

-- you can customize the Tricky text shake at the bottom of the script ↓↓↓

function onCreate()
    makeAnimatedLuaSprite('Static',(useAccelerantStaticTexture and 'AclrntTrickyStatic' or 'TrickyStatic'), 0, 0);
	addAnimationByPrefix('Static', 'Stat', 'Stat', 24, true);
	setGraphicSize('Static',1280,720);
	setObjectCamera('Static','camHUD');
	-- setProperty('Static.alpha', 0.6);
	-- setProperty('Static.visible', false);
	setProperty('Static.alpha', 0.00001);
	setProperty('Static.antialiasing', false);
	precacheImage('TrickyStatic');
    addLuaSprite('Static', false);
	
	makeLuaText('TrickyText', 'SUSSY BAKA', 1280, 0, 0);
	setTextSize('TrickyText', 100);
	setTextBorder('TrickyText', 0, 0);
	setTextFont('TrickyText', 'impact.ttf');
	setTextColor('TrickyText', '0xff0000');
	setTextAlignment('TrickyText', 'center');
	setObjectCamera('TrickyText','camHUD');
	setProperty('TrickyText.textField.multiline', false);
	-- setProperty('TrickyText.visible', false);
	setProperty('TrickyText.alpha', 0.00001);
	addLuaText('TrickyText');
	setObjectOrder('TrickyText', getObjectOrder('Static') + 1);

	-- I set the alpha to 0.00001 (not 0 and not .visible = false), 
	-- and because of that the game engine thinks it needs to load the
	-- sprites into the stage, although you can't actually see
	-- them. Like that, I can load sprites early and avoid lag.

	precacheSound('staticSound');
end

local function split(s, delimiter)
    local result = {};
    -- string.gmatch() explanation: https://www.ibm.com/docs/en/ias?topic=manipulation-stringgmatch-s-pattern#:~:text=Product%20list-,string.gmatch%20(s%2C%20pattern),-Last%20Updated%3A%202021
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function trim(s)
    -- string.gsub() explanation: https://www.lua.org/pil/20.1.html#:~:text=The-,string.gsub,-function%20has%20three
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
-- string patterns explanation: https://www.lua.org/pil/20.2.html


--[[
	This function is what makes
	the static effect and the text show up

	text - The string that will be displayed by the tricky text
	x - The x position of the tricky text
	y - The y position of the tricky text
--]]
local function DoTheStaticTrickyThing(text, x, y)
	if not (text and x and y) then
		return;
	end
	setTextString('TrickyText', text);
	setProperty('TrickyText.x', x);
	setProperty('TrickyText.y', y);
	-- setProperty('Static.visible', true);
	-- setProperty('TrickyText.visible', true);
	setProperty('Static.alpha', 0.6);
	setProperty('TrickyText.alpha', 1);
    playSound((useCoolerStaticSounds and 'coolerStaticSound'..getRandomInt(1,2) or 'staticSound'), 1, 'staticSound');
end

-- the max and min x and y positions for
-- the randomly generated Tricky text positions
local randomBounds = {--[[X]]{--[[min]]-200, --[[max]]200}, --[[Y]]{--[[min]]200, --[[max]]400}};

-- Event notes hooks
function onEvent(name, value1, value2)
    if name == 'Do a static' then
		-- we split the string into an array of strings
		local pos = split(trim(value2), ',');
		-- we chack if we need to put a random position
		for i=1,2 do
			if pos[i]:lower() == 'random' then
				pos[i] = tostring(getRandomInt(randomBounds[i][1], randomBounds[i][2]));
			end
		end
		-- we do the static tricky thing
		DoTheStaticTrickyThing(value1, tonumber(pos[1]), tonumber(pos[2]));
    end
end

function onSoundFinished(tag)
	-- we make the static effect and the text go away
	if tag == 'staticSound' then
        -- setProperty('Static.visible', false);
		-- setProperty('TrickyText.visible', false);
		setProperty('Static.alpha', 0.00001);
		setProperty('TrickyText.alpha', 0.00001);
    end
end

-----------------------------------------------------------------------
-- Tricky Text Shake
-----------------------------------------------------------------------

--[[
	This text shake was made to be an improved version of the original
	text shake and to look more like Madness Accelerant's text shake.

	If you want to make the shake accurate to FNF ONLINE VS, 
	then put the "most accurate to ONLINE VS." value for every
	variable that has them. If a variable has no "most accurate
	to ONLINE VS." value, then put the default value in the variable.
--]]

-- if this is true, the text will turn
local turnShake = true; -- default - true   most accurate to ONLINE VS. - false

-- if this is true, the text will move
local posShake = true; -- default - true

-- if both are true, it will do both,
-- and if both are false, it won't shake.



-- Shake speed in shakes per second
local shakeSpeed = 20; -- default - 20   most accurate to ONLINE VS. - 15

-- multiplies the random shake number
local shakeIntencity = 5; -- default - 5   most accurate to ONLINE VS. - 10

-- the turning angle from the X axis
local turnAmount = 1; -- default - 1

-- determines who much the angle
-- will change every second
local turnSpeed = 100; -- default - 100




-- represents the x value of the
-- mathematical function that we use
-- to change the angle of the Tricky text
local angleFuncX = 0;

-- time elapsed since last shake
local elapsedShake = 0;
function onUpdate(elapsed)
	if getProperty('TrickyText.alpha') == 0.00001 or (posShake == false and turnShake == false)then
		return;
	end


	-- if we want the text to shake by changing it's position
	if posShake then
		-- we add the elapsed time
		elapsedShake = elapsedShake + elapsed;
		if elapsedShake >= 1 / shakeSpeed then
			-- we tween the x and y offsets to a random position between -1 and 1 multiplied by shakeIntencity
			doTweenX('ShakeX','TrickyText.offset', getRandomFloat(0,1) * getRandomInt(-1,1) * shakeIntencity, 1 / shakeSpeed, 'linear');
			doTweenY('ShakeY','TrickyText.offset', getRandomFloat(0,1) * getRandomInt(-1,1) * shakeIntencity, 1 / shakeSpeed, 'linear');
			-- because the shake just happened, we set elapsedShake to 0
			elapsedShake = 0;
		end
	end

	-- if we want the text to shake by turning
	if turnShake then
		-- we increase the x value with time but *turnSpeed* times faster
		angleFuncX = angleFuncX + elapsed * turnSpeed;
		-- every 10 seconds, the x value will come back to 0
		if angleFuncX >= turnSpeed * 10 then
			-- I don't want the values to become too big,
			-- because I'm afraid the computer won't be able to handle it.
			angleFuncX = 0;
		end
		-- 		f(x) = sin(π∙x) ∙ turnAmount
		--  		       ↓
		-- 		TrickyText.angle = f(x)
		setProperty('TrickyText.angle', math.sin(math.pi * angleFuncX) * turnAmount);
		-- Mathematical functions are very useful for programming guys!
		-- Go learn some math!
	end
end