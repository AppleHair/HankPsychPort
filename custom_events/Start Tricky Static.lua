function onCreate()
    makeAnimatedLuaSprite('Static','TrickyStatic', 0, 0);
	addAnimationByPrefix('Static', 'Stat', 'Stat', 24, true);
	setGraphicSize('Static',1280,720);
	setObjectCamera('Static','camHud');
	setProperty('Static.visible', false);
	precacheImage('TrickyStatic');
    addLuaSprite('Static', false);
end

local doTheThing = false;
function DoTheStaticTrickyThing(text)
    setProperty('Static.visible', true);
    runTimer('StopStat', 0.01);
end

function onEvent(name, value1, value2)
    if name == 'Start Tricky Static' then
        doTheThing = true;
        DoTheStaticTrickyThing('CLOWN ENGAGED');
    end
    if name == 'Stop Tricky Static' and doTheThing then
        DoTheStaticTrickyThing('HEY!!');
        doTheThing = false;
    end
end

-- The thing itself:
function StepHit(id, direction, noteType, isSustainNote)
	if doTheThing and getRandomBool(20) then
        DoTheStaticTrickyThing('');
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag = 'StopStat' then
        setProperty('Static.visible', false);
    end
end