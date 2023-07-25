-- bounds a value to a maximum and minimum values
local function boundTo(val, min, max)
    return math.min(max, math.max(min, val));
end

local OnPsych06 = false;

function onGameOverStart()

    OnPsych06 = version:find('^v?0%.6') ~= nil;

    local lib = (OnPsych06 and "" or "substates");
    local follow = (OnPsych06 and "camFollowPos" or "camFollow");
    --               boolean           true            false

    addHaxeLibrary("GameOverSubstate", lib);
    runHaxeCode([[
        var bf = GameOverSubstate.instance.boyfriend;
        var follow = GameOverSubstate.instance.]]..follow..[[;

        bf.playAnim('deathLoop');
        follow.setPosition(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y);
        bf.playAnim('firstDeath');

        FlxG.camera.follow(follow);

        GameOverSubstate.instance.isFollowingAlready = true;
        GameOverSubstate.instance.updateCamera = false;
    ]]);

    -- we make the camera zoom smaller to make the game over screen more accurate to FNF ONLINE VS.
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 0.65);
end

-- camera speed multiplier
local cameraSpeed = 5;
function onUpdatePost(elapsed)
    if not inGameOver then
        return;
    end
    -- we will have to make our own linear interpolation of the camera's position to make it 
    -- move faster. we do this to make the game over screen more accurate to FNF ONLINE VS.
    setPropertyFromClass('flixel.FlxG', 'camera.followLerp', boundTo(elapsed * 0.6 * cameraSpeed /
        (getPropertyFromClass('flixel.FlxG', 'updateFramerate') / 60), 0, 1));
end