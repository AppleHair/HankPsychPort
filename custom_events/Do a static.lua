function onCreate()
    makeAnimatedLuaSprite('Static','TrickyStatic', 0, 0);
	addAnimationByPrefix('Static', 'Stat', 'Stat', 24, true);
	setGraphicSize('Static',1280,720);
	setObjectCamera('Static','camHud');
	-- setProperty('Static.alpha', 0.6);
	-- setProperty('Static.visible', false);
	setProperty('Static.alpha', 0.00001);
	precacheImage('TrickyStatic');
    addLuaSprite('Static', false);
	
	makeLuaText('TrickyText', 'SUSSY BAKA', 1280, 0, 0);
	setTextSize('TrickyText', 100);
	setTextBorder('TrickyText', 0, 0);
	setTextFont('TrickyText', 'impact.ttf');
	setTextColor('TrickyText', '0xff0000');
	setTextAlignment('TrickyText', 'center');
	setObjectCamera('TrickyText','camHud');
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

--[[
	This function is what makes
	the static effect and the text show up

	text - The string that will be displayed by the tricky text
	x - The x position of the tricky text
	y - The y position of the tricky text
--]]
local function DoTheStaticTrickyThing(text, x, y)
	setTextString('TrickyText', text);
	setProperty('TrickyText.x', x);
	setProperty('TrickyText.y', y);
	-- setProperty('Static.visible', true);
	-- setProperty('TrickyText.visible', true);
	setProperty('Static.alpha', 0.6);
	setProperty('TrickyText.alpha', 1);
    playSound('staticSound', 1, 'staticSound');
end

local function split(s, delimiter)
    result = {};
    -- go learn stuff: https://www.ibm.com/docs/en/ias?topic=manipulation-stringgmatch-s-pattern#:~:text=Product%20list-,string.gmatch%20(s%2C%20pattern),-Last%20Updated%3A%202021
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function trim(s)
    -- go learn stuff: https://www.lua.org/pil/20.1.html#:~:text=The-,string.gsub,-function%20has%20three
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
-- go learn string patterns: https://www.lua.org/pil/20.2.html


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
	-- we make the static effect and the text
	-- go away 
	if tag == 'staticSound' then
        -- setProperty('Static.visible', false);
		-- setProperty('TrickyText.visible', false);
		setProperty('Static.alpha', 0.00001);
		setProperty('TrickyText.alpha', 0.00001);
    end
end


-- determines who much the x value
-- will change every second
local turnSpeed = 170;
-- represents the x value of the
-- mathematical function that we use
-- to change the angle of the Tricky text
local angleFuncX = 0;
function onUpdate(elapsed)
	-- we increase the x value with time but *turnSpeed* times faster
	angleFuncX = angleFuncX + elapsed * turnSpeed;
	-- every 10 seconds, the x value will come back to 0
	if angleFuncX >= turnSpeed * 10 then
		-- I don't want the values to become too big,
		-- because I'm afraid the computer won't be able to handle it.
		angleFuncX = 0;
	end
	-- 		f(x) = sin(π∙x) ∙ 2.5
	--  		       ↓
	-- 		TrickyText.angle = f(x)
	setProperty('TrickyText.angle', math.sin(math.pi * angleFuncX) * 2.5);
	-- Mathematical functions are very useful for programming guys!
	-- Go learn some math!
end