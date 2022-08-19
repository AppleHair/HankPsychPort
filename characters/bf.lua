-- unfinished script!

function onCreate()
    addLuaScript('custom_events/Blood Effect', true);

    addHaxeLibrary('GameOverSubstate');
    -- addHaxeLibrary('CoolUtil');
    -- addHaxeLibrary('FlxPoint', 'flixel.math');
    -- addHaxeLibrary('FlxObject', 'flixel');
    -- addHaxeLibrary('FlxMath', 'flixel.math');

    precacheSound('splat');
end

local sustainArray = {
    'singLEFT',
    'singDOWN',
    'singUP',
    'singRIGHT'
}


function goodNoteHit(id, direction, noteType, isSustainNote)
    if boyfriendName ~= 'bf' or getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
        return;
    end
    if isSustainNote then
        triggerEvent('Play Animation', sustainArray[direction+1], 'boyfriend');
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
    runHaxeCode([[
        GameOverSubstate.instance.boyfriend.animation.curAnim.curFrame = 12;
        FlxG.camera.zoom = 0.65;
    ]]);

    --     camFollow2 = new FlxPoint(GameOverSubstate.instance.boyfriend.getGraphicMidpoint().x, GameOverSubstate.instance.boyfriend.getGraphicMidpoint().y);

    --     camFollowPos2 = new FlxObject(0, 0, 1, 1);
	-- 	   camFollowPos2.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
	-- 	   GameOverSubstate.instance.add(camFollowPos2);

    --     isFollowingAlready2 = false;
    --     updateCamera2 = false;
    -- ]]);
end

-- local cameraSpeed = 20000000000000000000000;
-- function onUpdatePost(elapsed)
--     if not inGameOver then
--         return;
--     end
--     runHaxeCode([[
--         if (updateCamera2) {
--             var lerpVal = CoolUtil.boundTo(]]..elapsed..[[ * 0.6 * ]]..cameraSpeed..[[, 0, 1);
-- 			   camFollowPos2.setPosition(FlxMath.lerp(camFollowPos2.x, camFollow2.x, lerpVal), FlxMath.lerp(camFollowPos2.y, camFollow2.y, lerpVal));
--         }
--         if (GameOverSubstate.instance.boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready2) {
--             FlxG.camera.follow(camFollowPos2, LOCKON, 1);
--             isFollowingAlready2 = true;
--             updateCamera2 = true;
--         }
--     ]]);
-- end

-- It just doesn't work...