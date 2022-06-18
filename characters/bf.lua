function onCreate()
    addLuaScript('custom_events/Blood Effect', true);

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