function onGameOverStart()
    addHaxeLibrary('GameOverSubstate', 'substates');
    runHaxeCode([[
        var bf = GameOverSubstate.instance.boyfriend;
        var follow = GameOverSubstate.instance.camFollow;

        bf.playAnim('deathLoop');
        follow.setPosition(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y);
        bf.playAnim('firstDeath');

        FlxG.camera.follow(follow);
        camera.followLerp = 3;

        GameOverSubstate.instance.moveCamera = true;
    ]]);

    -- we make the camera zoom smaller to make the game over screen more accurate to FNF ONLINE VS.
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 0.65);
end