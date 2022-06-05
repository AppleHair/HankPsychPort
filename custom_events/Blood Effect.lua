function onCreate()
    -- I present to you... blood
	makeAnimatedLuaSprite('bloodEffect','blood', 0, 0);
	setProperty('bloodEffect.flipX', true);
	addAnimationByPrefix('bloodEffect', 'splat', 'blood 1', 24, false);
	setProperty('bloodEffect.visible', false);
	addLuaSprite('bloodEffect',true);

    precacheImage('blood');
end


function onEvent(name, value1, value2)
    --Value1: x   Value2: y
    if name == 'Set Blood Effect Pos' then
        setProperty('bloodEffect.x', tonumber(value1));
        setProperty('bloodEffect.y', tonumber(value2));
    end

    if name == 'Add Blood Effect' then
        luaSpritePlayAnimation('bloodEffect', 'splat', true);
        setProperty('bloodEffect.visible', true);
    end
end

function onUpdate(elapsed)
    if getProperty('bloodEffect.animation.curAnim.finished') then
		setProperty('bloodEffect.visible', false);
	end
end