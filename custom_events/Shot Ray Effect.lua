function onCreate()
    -- The shot ray creation
	makeLuaSprite('shotRay','shotRay', 0, 0);
	-- setProperty('shotRay.alpha', 0.7);
	-- setProperty('shotRay.visible', false);
    setProperty('shotRay.alpha', 0.00001);
	addLuaSprite('shotRay',true);

    precacheImage('shotRay');
end

local RayFade = 0;
function onEvent(name, value1, value2)
    if name == 'Set Shot Ray Pos' then
        --Value1: x   Value2: y
        setProperty('shotRay.x', tonumber(value1));
        setProperty('shotRay.y', tonumber(value2));
    end
    if name == 'Add Shot Ray' then
        -- setProperty('shotRay.visible', true);
        setProperty('shotRay.alpha', 0.7);
        RayFade = 0.07;
    end
end

function onUpdate(elapsed)
    -- THE FADE
    if RayFade > 0 then
        RayFade = RayFade - elapsed;
        if RayFade <= 0 then
            setProperty('shotRay.alpha', 0.00001);
            RayFade = 0;
        end
    end
end