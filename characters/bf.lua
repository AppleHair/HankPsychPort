function onCreate()
    -- we add the blood effect script
    addLuaScript('custom_events/Blood Effect', true);

    precacheSound('splat');

    -- onlinePlay = true | false
    runningUMM = onlinePlay ~= nil;
end

-- Related to dealing with UMM bugs. 
-- Don't bother looking into this.
local forFuckSake = true;

-- Related to dealing with UMM bugs. 
-- Don't bother looking into this.
local function BulletCondition(messageStart, id, noteType)
    -- related to dealing with UMM bugs. 
    -- Don't bother looking into this.
    if runningUMM and onlinePlay then
        if (not leftSide) then
            send(messageStart..tostring(getPropertyFromGroup('notes', id, 'gfNote') or
            noteType ~= 'Bullet Note'));
            return getPropertyFromGroup('notes', id, 'gfNote') or noteType ~= 'Bullet Note';
        end
        local copy = forFuckSake;
        forFuckSake = true;
        return copy;
    end

    -- character must be bf and the code is 
    -- only relevant to bullet notes that are hit by boyfriend
    return getPropertyFromGroup('notes', id, 'gfNote') or noteType ~= 'Bullet Note';
end

-- Related to dealing with UMM bugs. 
-- Don't bother looking into this.
function onReceive(message)
    if message:find("BulletMiss ") then
        message = message:sub(12, #message);
        if message == "true" then
            forFuckSake = true;
        elseif message == "false" then
            forFuckSake = false;
        end
        noteMiss();
    end
    if message:find("BulletHit ") then
        message = message:sub(11, #message);
        if message == "true" then
            forFuckSake = true;
        elseif message == "false" then
            forFuckSake = false;
        end
        goodNoteHit();
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    -- we check stuff(look at the last return inside the function)
    if BulletCondition("BulletHit ", id, noteType) then
        return;
    end
    -- play dodge animation
    triggerEvent('Play Animation', 'dodge', 'boyfriend');
end

-- another UMM online play bug handeling related thing
local overrideUMMsMiss = false;

function noteMiss(id, noteData, noteType, isSustainNote)
    -- just move on for now don't look at this function
    if BulletCondition("BulletMiss ", id, noteType) then
        return;
    end
    -- we make boyfriend play his hurt animation
    triggerEvent('Play Animation', 'hurt', 'boyfriend');

    -- another UMM online play bug handeling related thing
    if onlinePlay and leftSide then
        overrideUMMsMiss = true;
    end
    -- we set the blood effect's position
    triggerEvent('Set Blood Effect Pos', defaultBoyfriendX - 264, defaultBoyfriendY + 67);
    -- we make the blood effect play it's animation
    triggerEvent('Add Blood Effect', '', '');
    -- if the bullet note killed the player instantly
    if getProperty('health') <= 0 then
        -- switch the boyfriend in GameOverSubstate to bf-hanked
        setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-hanked');
    end
    -- we play the splat sound
    playSound('splat');
end

function onUpdatePost(elapsed)
    -- another UMM online play bug handeling related thing
    if runningUMM and overrideUMMsMiss then
        if getProperty('boyfriend.animation.curAnim.name') ~= "hurt" then
            triggerEvent('Play Animation', 'hurt', 'boyfriend');
            return;
        end
        overrideUMMsMiss = false;
    end
end

function onUpdate(elapsed)
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