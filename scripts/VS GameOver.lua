-- short for linear interpolation
local function lerp(a, b, ratio)
    return a + ratio * (b - a);
end

-- bounds a value to a maximum and minimum values
local function boundTo(val, min, max)
    return math.min(max, math.max(min, val));
end

function onGameOverStart()
    -- we set the current frame of the current animation to 12 and make the camera on game over
    -- move instantly to make the game over screen more accurate to FNF ONLINE VS.
    -- the .xml of the bf-dead and bf-hanked is modified to start at 12.
    setPropertyFromClass('GameOverSubstate', 'instance.boyfriend.animation.curAnim.curFrame', 12);
    -- there should be a boolean moveCamInstantly variable on GameOverSubstate that lets you do that.
    -- it's kinda annoying to do it like that.

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
    -- there should just be a cameraSpeed variable for GameOverSubstate in the source code. Just saying...
end