function onCreate()
    addLuaScript('custom_events/Blood Effect', true);
    triggerEvent('Set Blood Effect Pos', 550, 0);
    --triggerEvent('Set Shot Ray Pos', 230, 360);
    precacheSound('splat');
end

local sustainArray = {
    'singLEFT',
    'singDOWN',
    'singUP',
    'singRIGHT'
}


function goodNoteHit(id, direction, noteType, isSustainNote)
    if not(boyfriendName == 'bf' or boyfriendName == 'bf-clone') or getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
        return;
    end
    if isSustainNote then
        triggerEvent('Play Animation', sustainArray[direction+1], 'boyfriend');
    end
    if noteType == 'Bullet Note' then
        triggerEvent('Play Animation', 'dodge', 'boyfriend');
        --triggerEvent('Add Shot Ray', '', '');
        --cameraShake('game', 0.0075, 0.07);
    end
end

function noteMiss(id, noteData, noteType, isSustainNote)
    if not(boyfriendName == 'bf' or boyfriendName == 'bf-clone') or 
    getPropertyFromGroup('notes', id, 'gfNote') or
    noteType ~= 'Bullet Note' then
        return;
    end
    triggerEvent('Play Animation', 'hurt', 'boyfriend');
    triggerEvent('Add Blood Effect', '', '');
    playSound('splat');
end