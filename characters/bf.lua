function onCreate()
    -- we add the blood effect script
    addLuaScript('custom_events/Blood Effect', true);

    precacheSound('splat');
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    -- character must be bf and the code is 
    -- only relevant to bullet notes that are hit by boyfriend
    if boyfriendName ~= 'bf' or 
        getPropertyFromGroup('notes', id, 'gfNote') or
        noteType ~= 'Bullet Note' then
        return;
    end
    -- play dodge animation
    triggerEvent('Play Animation', 'dodge', 'boyfriend');
end


function noteMiss(id, noteData, noteType, isSustainNote)
    -- character must be bf and the code is 
    -- only relevant to bullet notes that are missed by boyfriend
    if boyfriendName ~= 'bf' or 
        getPropertyFromGroup('notes', id, 'gfNote') or
        noteType ~= 'Bullet Note' then
        return;
    end
    -- we make boyfriend play his hurt animation
    triggerEvent('Play Animation', 'hurt', 'boyfriend');
    -- we set the blood effect's position
    triggerEvent('Set Blood Effect Pos', 550, 0);
    -- we make the blood effect play it's animation
    triggerEvent('Add Blood Effect', '', '');
    -- if the bullet note killed the player instantly
    if getProperty('health') <= 0 then
        -- switch the boyfriend in GameOverSubstate to bf-hanked
        setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-hanked');
    end
    -- we play the splat sound
    playSound('splat');
end

function onUpdate(elapsed)
    -- if the player just pressed space
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
        -- make boyfriend do the hey animation
        triggerEvent('Play Animation', 'hey', 'bf');
    end
end