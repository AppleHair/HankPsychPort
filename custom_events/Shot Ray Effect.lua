function onCreate()
    -- The shot ray creation
	makeLuaSprite('shotRay','shotRay', 0, 0);
	setProperty('shotRay.alpha', 0.7);
	setProperty('shotRay.visible', false);
	addLuaSprite('shotRay',true);

    precacheImage('shotRay');
end

function onEvent(name, value1, value2)
    if name == 'Set Shot Ray Pos' then
        setProperty('shotRay.x', tonumber(value1));
        setProperty('shotRay.y', tonumber(value2));
    end
    if name == 'Add Shot Ray' then
        setProperty('shotRay.visible', true);
		runTimer('RayFade', 0.07);
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'RayFade' then
		setProperty('shotRay.visible', false);
	end
end