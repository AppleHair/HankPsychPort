function onCreate()
    -- we add the blood effect script
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
    -- character must be bf and the code is 
    -- only relevant to notes that are hit by boyfriend
    if boyfriendName ~= 'bf' or getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
        return;
    end
    -- if the note is a sustain note
    if isSustainNote then
        -- play the correct sing animation (restores the sustain animations 
        -- that are stoped by the VS Sustain script)
        triggerEvent('Play Animation', getProperty('singAnimations['..direction..']'), 'boyfriend');
    end
    if noteType == 'Bullet Note' then
        -- play dodge animation
        triggerEvent('Play Animation', 'dodge', 'boyfriend');
    end
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


function onGameOverStart()
    -- we set the current frame of the current animation to 12 and make the camera on game over
    -- move instantly to make the game over screen more accurate to FNF ONLINE VS.
    -- the .xml of the bf-dead and bf-hanked is modified to start at 12.
    setPropertyFromClass('GameOverSubstate', 'instance.boyfriend.animation.curAnim.curFrame', 12);
    -- why do I have to do this...
    -- there should be a boolean moveCamInstantly variable on GameOverSubstate that lets you do that!

    -- we make the camera zoom smaller to make the game over screen more accurate to FNF ONLINE VS.
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 0.65);
end

-- camera speed multiplier
local cameraSpeed = 5;
function onUpdate(elapsed)
    if not inGameOver then
        return;
    end
    -- we will have to make our own linear interpolation of the camera's position to make it 
    -- move faster. we do this to make the game over screen more accurate to FNF ONLINE VS.
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
    -- there should just be a cameraSpeed variable for GameOverSubstate in the source code. WHY DO I HAVE TO DO THIS!!
    -- Shadow, I know you worked on adding more stuff to GameOverSubstate to make it more accessible to lua users,
    -- but asking for a cameraSpeed and moveCamInstantly variables isn't asking for much.

    -- It not like I asked you for lua sprites in GameOverSubstate (although it can be really useful to use
    -- lua sprites instead of ONE GIANT FUCKING GAME OVER SPRITE).
end