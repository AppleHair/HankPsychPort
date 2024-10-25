
local inPsych071h = false;

function onGameOverStart()
    addHaxeLibrary('GameOverSubstate', 'substates');
    runHaxeCode([[
        var bf = GameOverSubstate.instance.boyfriend;
        var follow = GameOverSubstate.instance.camFollow;

        // the follow position will be
        // determined by the boyfriend's
        // midpoint on the "deathLoop" animation
        bf.playAnim('deathLoop');
        follow.setPosition(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y);
        bf.playAnim('firstDeath');

        FlxG.camera.follow(follow);
    ]]);

    -- we make the camera zoom smaller to make the game over screen more accurate to FNF ONLINE VS.
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 0.65);

    -- check if we're in version 0.7.1h
    inPsych071h = version:find('^v?0%.7%.1') ~= nil;

    -- the way we change the follow lerp in each version is different
    if inPsych071h then
        setProperty('isFollowingAlready', true);
        setProperty('updateCamera', false);
        setPropertyFromClass('flixel.FlxG', 'camera.followLerp', 0);
        return;
    end

    setPropertyFromClass('flixel.FlxG', 'camera.followLerp', 0.06);
end

function onUpdatePost(elapsed)
    if not (inGameOver and inPsych071h) then
        return;
    end
    -- we force our own follow lerp (only in 0.7.1h)
    setPropertyFromClass('flixel.FlxG', 'camera.followLerp', elapsed * 3 /
    (getPropertyFromClass('flixel.FlxG', 'updateFramerate') / 60));
end