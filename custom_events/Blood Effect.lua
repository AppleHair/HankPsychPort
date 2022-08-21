function onCreate()
    -- I present to you... blood
	makeAnimatedLuaSprite('bloodEffect','blood', 0, 0);
	setProperty('bloodEffect.flipX', true);
	addAnimationByPrefix('bloodEffect', 'splat', 'blood 1', 24, false);
	-- setProperty('bloodEffect.visible', false);
    setProperty('bloodEffect.alpha', 0.00001);
	addLuaSprite('bloodEffect',true);
    -- I set the alpha to 0.00001 (not 0 and not .visible = false), 
	-- and because of that the game engine thinks it needs to load the
	-- sprites into the stage, although you can't actually see
	-- them. Like that, I can load sprites early and avoid lag.

    precacheImage('blood');
end


function onEvent(name, value1, value2)
    --Value1: x   Value2: y
    if name == 'Set Blood Effect Pos' then
        setProperty('bloodEffect.x', tonumber(value1));
        setProperty('bloodEffect.y', tonumber(value2));
    elseif name == 'Add Blood Effect' then
        playAnim('bloodEffect', 'splat', true);
        -- setProperty('bloodEffect.visible', true);
        setProperty('bloodEffect.alpha', 1);
    end
end

function onUpdate(elapsed)
    if getProperty('bloodEffect.animation.curAnim.finished') then
		-- setProperty('bloodEffect.visible', false);
        setProperty('bloodEffect.alpha', 0.00001);
	end
end