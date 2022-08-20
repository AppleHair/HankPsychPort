function onCreate()
    addLuaScript('custom_events/Blood Effect', true);

    precacheSound('splat');
end

-- short for linear interpolation
local function lerp(a, b, ratio)
    return a + ratio * (b - a);
end

-- bounds a value to a maximum and minimum values
local function boundTo(val, min, max)
    return math.min(max, math.max(min, val));
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if boyfriendName ~= 'bf' or getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
        return;
    end
    if isSustainNote then
        triggerEvent('Play Animation', getProperty('singAnimations['..direction..']'), 'boyfriend');
    end
    if noteType == 'Bullet Note' then
        triggerEvent('Play Animation', 'dodge', 'boyfriend');
    end
end


function noteMiss(id, noteData, noteType, isSustainNote)
    if boyfriendName ~= 'bf' or 
    getPropertyFromGroup('notes', id, 'gfNote') or
    noteType ~= 'Bullet Note' then
        return;
    end
    triggerEvent('Play Animation', 'hurt', 'boyfriend');
    triggerEvent('Set Blood Effect Pos', 550, 0);
    triggerEvent('Add Blood Effect', '', '');
    if getProperty('health') <= 0 then
        setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-hanked');
    end
    playSound('splat');
end


function onGameOverStart()
    setPropertyFromClass('GameOverSubstate', 'instance.boyfriend.animation.curAnim.curFrame', 12);
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 0.65);
end

local cameraSpeed = 5;
function onUpdatePost(elapsed)
    if not inGameOver then
        return;
    end
    local lerpVal = boundTo(elapsed * 0.6 * cameraSpeed, 0, 1);
    local followPosX = getPropertyFromClass('GameOverSubstate', 'instance.camFollowPos.x');
    local followX = getPropertyFromClass('GameOverSubstate', 'instance.camFollow.x');
    local followPosY = getPropertyFromClass('GameOverSubstate', 'instance.camFollowPos.y');
    local followY = getPropertyFromClass('GameOverSubstate', 'instance.camFollow.y');
    setPropertyFromClass('GameOverSubstate', 'instance.camFollowPos.x', lerp(followPosX, followX, lerpVal));
    setPropertyFromClass('GameOverSubstate', 'instance.camFollowPos.y', lerp(followPosY, followY, lerpVal));
    if getPropertyFromClass('GameOverSubstate', 'instance.updateCamera') then
        setPropertyFromClass('GameOverSubstate', 'instance.updateCamera', false);
    end
end