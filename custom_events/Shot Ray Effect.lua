function onCreate()
    -- The shot ray creation
	makeLuaSprite('shotRay','shotRay', 0, 0);
	-- setProperty('shotRay.alpha', 0.7);
	-- setProperty('shotRay.visible', false);
    setProperty('shotRay.alpha', 0.00001);
	addLuaSprite('shotRay',true);
    -- I set the alpha to 0.00001 (not 0 and not .visible = false), 
	-- and because of that the game engine thinks it needs to load the
	-- sprites into the stage, although you can't actually see
	-- them. Like that, I can load sprites early and avoid lag.

    precacheImage('shotRay');
end

-- determines how much time it takes 
-- for the arrow to "fade"
local RayFade = 0;
function onEvent(name, value1, value2)
    if name == 'Set Shot Ray Pos' then
        --Value1: x   Value2: y
        setProperty('shotRay.x', tonumber(value1));
        setProperty('shotRay.y', tonumber(value2));
    elseif name == 'Add Shot Ray' then
        -- setProperty('shotRay.visible', true);
        setProperty('shotRay.alpha', 0.7);
        RayFade = 0.07;
    end
end

function onUpdate(elapsed)
    -- THE FADE
    if RayFade > 0 then
        -- we decrease the fade value with time
        RayFade = RayFade - elapsed;
        -- we check if the fade value passed 0
        if RayFade <= 0 then
            -- we set the fade value to 0
            -- and make the shot ray invisible
            setProperty('shotRay.alpha', 0.00001);
            -- setProperty('shotRay.visible', false);
            RayFade = 0;
        end
    end
end