function goodNoteHit(id, direction, noteType, isSustainNote)
    if isSustainNote and boyfriendName == 'bf-clone' and not(getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing') then
        if direction == 0 then
            triggerEvent('Play Animation', 'singLEFT', 'boyfriend');
        end
        if direction == 1 then
            triggerEvent('Play Animation', 'singDOWN', 'boyfriend');
        end
        if direction == 2 then
            triggerEvent('Play Animation', 'singUP', 'boyfriend');
        end
        if direction == 3 then
            triggerEvent('Play Animation', 'singRIGHT', 'boyfriend');
        end
    end
end