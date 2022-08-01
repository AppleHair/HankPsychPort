

--[[
    Checks if a curtain value is in a curtain array.

    arr - Array to check
    value - Value to check
--]]
local function isInArray(arr, value)
	for i,v in ipairs(arr) do 
        if value == v then
            return true;
        end
    end
	return false;
end

--[[
    returns the index of the first member
    from a curtain array that is smaller
    then a curtain value. if the array doesn't
     have a member that is smaller than the
     value, the function will return nil.

    arr - Array to check
    value - Value to check
--]]
local function getSmallerInArray(arr, value)
	for i,v in ipairs(arr) do 
		if v <= value then
            return i;
        end
	end
	return nil;
end

--[[
    returns the index of the first value in
    a curtain array that matches a curtain 
    value. I no value in the array matches, 
    the function will return nil.

    arr - Array to check
    value - Value to check
--]]
local function indexOf(arr, value)
    for i,v in ipairs(arr) do 
        if value == v then
            return i;
        end
    end
    return nil;
end

--[[
    Checks if a string starts with a curtain
    sequence of characters

    start - A string value of the initual sequence of characters
            that needs to be checked
--]]
function string:startswith(start)
    return self:sub(1, #start) == start;
end

-- stores all the Bullet notes' strum time
-- this is being set later
local bulletNotesArray = {};

-- stores opponent notes that have the same
-- strum time as a bullet note
local theAnnoyingOnes = {{--[[strum times]]},{--[[note datas]]}};

-- stores the x and y positions of the shot ray
local shotRayPos = {220, 360};



function onCreatePost()
    -- adding the required script
    addLuaScript('custom_events/Shot Ray Effect', true);

    -- setting the shot ray position
    triggerEvent('Set Shot Ray Pos', shotRayPos[1], shotRayPos[2]);

    -- getting Bullet notes' strum time
    for i = 0, getProperty('unspawnNotes.length')-1 do
        -- Checking if the note is an Bullet Note
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' then
            -- adding the strum time to the array
            table.insert(bulletNotesArray, getPropertyFromGroup('unspawnNotes', i, 'strumTime'));
        end
    end

    -- getting strum times and note datas for opponent notes that have the same strum time as a bullet note
    for i = 0, getProperty('unspawnNotes.length')-1 do
        -- Checking if the note is an opponent note that has the same strum time as a bullet note
        local gfNote = getPropertyFromGroup('unspawnNotes', i, 'gfNote');
        local mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress');
        local inBulletNotesArray = isInArray(bulletNotesArray, getProperty('unspawnNotes', i, 'strumTime'));
        local noteType = getPropertyFromGroup('unspawnNotes', i, 'noteType');

        if (not mustPress) and inBulletNotesArray and (not gfNote) and noteType ~= 'Bullet Note' then
            -- makes the note have no animation
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
            -- adds the strum time to the array
            table.insert(theAnnoyingOnes[1], getPropertyFromGroup('unspawnNotes', i, 'strumTime'));
            -- adds the note data to the array
            table.insert(theAnnoyingOnes[2], getPropertyFromGroup('unspawnNotes', i, 'noteData'));
        end
    end
    -- TODO: fix hank's shoot animation not playing correctly when 
    -- hank presses a note at the same time with a bullet note.
    -- there is already a system that tries to handle this in the code
    -- (theAnnoyingOnes table and every way it's used), but it just doen't 
    -- work consistantly, and I have no idea why.
end

function onUpdatePost(elapsed)
    -- character must be Hank!!
    if dadName ~= 'hank' then
        return;
    end

                    -- Hank shoot animation section --

    -- checks if a bullet note passed
    if getSmallerInArray(bulletNotesArray, getSongPosition()) ~= nil then
        -- gets the strum time of the current bullet note
        local theStrumTime = bulletNotesArray[getSmallerInArray(bulletNotesArray, getSongPosition())];
        while getSmallerInArray(bulletNotesArray, getSongPosition()) ~= nil do
            -- removing the strum time from the array
            table.remove(bulletNotesArray, getSmallerInArray(bulletNotesArray, getSongPosition()));
        end
        -- adding shot ray
        triggerEvent('Add Shot Ray', '', '');

        -- Gets what sing animation Hank is currently on
        local curAnim;
        local singLEFT;
        local singDOWN;
        local singUP;
        local singRIGHT;
        if isInArray(theAnnoyingOnes[1], theStrumTime) then
            curAnim = theAnnoyingOnes[2][indexOf(theAnnoyingOnes[1], theStrumTime)];
            singLEFT = curAnim == 0;
            singDOWN = curAnim == 1;
            singUP = curAnim == 2;
            singRIGHT = curAnim == 3;
        else
            curAnim = getProperty('dad.animation.curAnim.name');

            singLEFT = curAnim:startswith('singLEFT');
            singDOWN = curAnim:startswith('singDOWN');
            singUP = curAnim:startswith('singUP');
            singRIGHT = curAnim:startswith('singRIGHT');
        end

        -- playing shoot animation
        if singLEFT then
            triggerEvent('Play Animation', 'shootLEFT', 'dad');
		elseif singRIGHT then
            triggerEvent('Play Animation', 'shootRIGHT', 'dad');
		elseif singDOWN then
            triggerEvent('Play Animation', 'shootDOWN', 'dad');
		else
            triggerEvent('Play Animation', 'shootUP', 'dad');
		end

        -- shacking camera
        cameraShake('game', 0.0075, 0.07);
    end
end