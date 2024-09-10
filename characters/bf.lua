function onCreate()
    -- we add the blood effect script
    addLuaScript('custom_events/Blood Effect', true);

    precacheSound('splat');

    -- onlinePlay = true | false
    runningUMM = onlinePlay ~= nil;
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    -- only relevant to bullet notes that are missed by boyfriend
    if getPropertyFromGroup('notes', id, 'gfNote') or noteType ~= 'Bullet Note' then
        return;
    end
    -- play dodge animation
    triggerEvent('Play Animation', 'dodge', 'boyfriend');
end

-- Tells if extra visual effects
-- should be added to the game over
-- screen to make it look like bf
-- had been shot.
local hanked = false;

function noteMiss(id, noteData, noteType, isSustainNote)
    -- only relevant to bullet notes that are missed by boyfriend
    if getPropertyFromGroup('notes', id, 'gfNote') or noteType ~= 'Bullet Note' then
        return;
    end
    -- we make boyfriend play his hurt animation
    triggerEvent('Play Animation', 'hurt', 'boyfriend');

    -- we set the blood effect's position
    triggerEvent('Set Blood Effect Pos', defaultBoyfriendX - 264, defaultBoyfriendY + 67);
    -- we make the blood effect play it's animation
    triggerEvent('Add Blood Effect', '', '');
    -- if the bullet note killed the player instantly
    if getProperty('health') <= 0 then
        -- extra visual effects should be
        -- added to the game over screen
        hanked = true;
    end
    -- we play the splat sound
    playSound('splat');
end

function onGameOverStart()
    -- adds bullet shot visual
    -- effects if needed

    -- There's a bug with getProperty not
    -- working consistently for GameOverSubstate,
    -- so we have to use getPropertyFromClass
    local bfX = getPropertyFromClass('substates.GameOverSubstate', 'instance.boyfriend.x');
    local bfY = getPropertyFromClass('substates.GameOverSubstate', 'instance.boyfriend.y');

    if hanked then
        makeLuaSprite('bulletHole', 'hole', bfX + 193, bfY + 88);
		addLuaSprite('bulletHole', true);
		
		makeAnimatedLuaSprite('blood', 'blood', bfX - 170, bfY - 200);
		setProperty('blood.flipX', true);
	    addAnimationByPrefix('blood', 'splat', 'blood 1', 24, false);
        setProperty('blood.alpha', 1);
		playAnim('blood', 'splat', true);
        addLuaSprite('blood', true);
		
		makeLuaSprite('bulletRay', 'shotRay', bfX - 80, bfY + 109);
        setProperty('bulletRay.alpha', 1);
		addLuaSprite('bulletRay', false);
		doTweenAlpha('rayFade', 'bulletRay', 0, 0.2);
    end
end

function onUpdate(elapsed)
    -- if the game over screen is active
    -- and the extra visual effects are used
    if inGameOver and hanked then
        if getProperty('blood.animation.curAnim.finished') then
            -- setProperty('bloodEffect.visible', false);
            setProperty('blood.alpha', 0.00001);
        end
    end
    -- UMM has different conditions for
    -- the purpose of the code ahead
    if runningUMM then
        return;
    end
    -- if the player just pressed space
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
        -- make boyfriend do the hey animation
        triggerEvent('Play Animation', 'hey', 'bf');
    end
end