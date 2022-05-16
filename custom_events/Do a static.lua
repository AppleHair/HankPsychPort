function onCreate()
    makeAnimatedLuaSprite('Static','TrickyStatic', 0, 0);
	addAnimationByPrefix('Static', 'Stat', 'Stat', 24, true);
	setGraphicSize('Static',1280,720);
	setObjectCamera('Static','camHud');
	setProperty('Static.visible', false);
	setProperty('Static.alpha', 0.5);
	precacheImage('TrickyStatic');
    addLuaSprite('Static', false);
	
	makeLuaText('TrickyText', 'SUSSY BAKA', 1280, 0, 0);
	setTextItalic('TrickyText', true);
	setTextSize('TrickyText', 150);
	setTextBorder('TrickyText', 0, 0);
	setTextFont('TrickyText', 'impact.ttf');
	setTextColor('TrickyText', '0xff0000');
	setTextAlignment('TrickyText', 'center');
	setObjectCamera('TrickyText','camGame');
	setProperty('TrickyText.visible', false);
	addLuaText('TrickyText');
	doTweenAngle('TextRotRight', 'TrickyText', 2.5, 0.1, 'quadIn');
end

function DoTheStaticTrickyThing(text, x, y)
	setTextString('TrickyText', text);
	setProperty('TrickyText.x', x);
	setProperty('TrickyText.y', y);
	setProperty('TrickyText.visible', true);
    setProperty('Static.visible', true);
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
        setProperty('Static.visible', false);
		setProperty('TrickyText.visible', false);
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