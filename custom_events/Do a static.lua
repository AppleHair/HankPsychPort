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
	doTweenAngle('TextRotRight', 'TrickyText', 2.5, 0.1, 'quadIn');

	precacheSound('staticSound');
end

function DoTheStaticTrickyThing(text, x, y)
	setTextString('TrickyText', text);
	setProperty('TrickyText.x', x);
	setProperty('TrickyText.y', y);
	-- setProperty('Static.visible', true);
	-- setProperty('TrickyText.visible', true);
	setProperty('Static.alpha', 0.6);
	setProperty('TrickyText.alpha', 1);
    playSound('staticSound', 1, 'staticSound');
end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local pos;
-- Event notes hooks
function onEvent(name, value1, value2)
    if name == 'Do a static' then
		pos = Split(tostring(value2), ', ');
		DoTheStaticTrickyThing(tostring(value1), tonumber(pos[1]), tonumber(pos[2]));
    end
end

function onSoundFinished(tag)
	if tag == 'staticSound' then
        -- setProperty('Static.visible', false);
		-- setProperty('TrickyText.visible', false);
		setProperty('Static.alpha', 0.00001);
		setProperty('TrickyText.alpha', 0.00001);
    end
end

function onTweenCompleted(tag)
	if tag == 'TextRotRight' then
		doTweenAngle('TextRotLeft', 'TrickyText', -2.5, 0.01, 'quadIn');
	end
	if tag == 'TextRotLeft' then
		doTweenAngle('TextRotRight', 'TrickyText', 2.5, 0.01, 'quadIn');
	end
end