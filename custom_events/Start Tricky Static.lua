function onCreate()
    makeAnimatedLuaSprite('Static','TrickyStatic', 0, 0);
	addAnimationByPrefix('Static', 'Stat', 'Stat', 24, true);
	setGraphicSize('Static',1280,720);
	setObjectCamera('Static','camHud');
	setProperty('Static.visible', false);
	setProperty('Static.alpha', 0.7);
	precacheImage('TrickyStatic');
    addLuaSprite('Static', false);
	
	makeLuaText('TrickyText', 'SUSSY BAKA', 1280, 0, 0);
	setTextItalic('TrickyText', true);
	setTextSize('TrickyText', 110);
	setTextBorder('TrickyText', 0, 0);
	setTextFont('TrickyText', 'impact.ttf');
	setTextColor('TrickyText', '0xff0000');
	setTextAlignment('TrickyText', 'center');
	setProperty('TrickyText.visible', false);
	addLuaText('TrickyText');
end


local strings = {'SUS','SUSSY','AMOGUS','IMPASTA','SUSSY BAKA'};
local minY = 200;
local maxY = 400;

local minX = -200;
local maxX = 200;


local doTheThing = false;
function DoTheStaticTrickyThing(text, x, y)
	setTextString('TrickyText', text);
	setProperty('TrickyText.x', x);
	setProperty('TrickyText.y', y);
	setProperty('TrickyText.visible', true);
    setProperty('Static.visible', true);
    playSound('staticSound', 1, 'staticSound');
end

function onEvent(name, value1, value2)
    if name == 'Start Tricky Static' then
        doTheThing = true;
		if tostring(value1) == 'true' then
        	DoTheStaticTrickyThing('CLOWN ENGAGED', 50, 350);
		end
    end
    if name == 'Stop Tricky Static' and doTheThing then
        doTheThing = false;
    end
	if name == 'Do a HAY!!! static' and not doTheThing then
        DoTheStaticTrickyThing('HAY!!!', -100, 250);
    end
end

-- The thing itself:
function onStepHit()
	if doTheThing and getRandomBool(6) then
        DoTheStaticTrickyThing(strings[getRandomInt(1, table.getn(strings))], getRandomInt(minX, maxX), getRandomInt(minY, maxY));
    end
end

function onSoundFinished(tag)
	if tag == 'staticSound' then
        setProperty('Static.visible', false);
		setProperty('TrickyText.visible', false);
    end
end