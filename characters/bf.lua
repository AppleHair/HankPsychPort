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
    -- I don't have to use runHaxeCode here, but there is a high chance I will have to in the future.
    runHaxeCode([[
        GameOverSubstate.instance.boyfriend.animation.curAnim.curFrame = 12;
        FlxG.camera.zoom = 0.65;
    ]]);
    -- TODO: make the camera's lerp faster on game over
end

--function onUpdatePost(elapsed)
--    if not inGameOver then
--        return;
--    end
--    runHaxeCode([[
    
--    ]]);
--end