

--[[
    Checks if a curtain value is in a curtain array

    arr - Array to check
    value - Value to be checked
]]
function IsInArray(arr, value)
	for i=1,table.getn(arr) do
		if arr[i] == value then
            return true;
        end
	end
	return false;
end

--[[
    returns the index of the first member
    from a curtain array that is smaller
    then a curtain value.
    if the array doesn't have a member that
    is smaller than the value, the function 
    will return nil.

    arr - Array to check
    value - Value to be checked
]]
function GetSmallerInArray(arr, value)
	for i=1,table.getn(arr) do
		if arr[i] <= value then
            return i;
        end
	end
	return nil;
end

--[[
    Checks if a string starts with a curtain
    sequence of characters

    start - a string value of the initual sequence of characters
            that needs to be checked
]]
function string:startswith(start)
    return self:sub(1, #start) == start;
end

-- stores all the Bullet notes' strum time
-- this is being set later
local bulletNotesArray = {};

-- stores the x(1) and y(2) positions of the shot ray
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
end

function onUpdate(elapsed)
    -- character must be Hank!!
    if not(dadName == 'hank' or dadName == 'hank2') then
        return;
    end


                    -- Hank shoot animation section --

    -- checks if a bullet note passed
    if GetSmallerInArray(bulletNotesArray, getSongPosition()) ~= nil then
        while GetSmallerInArray(bulletNotesArray, getSongPosition()) ~= nil do
            -- removing the strum time from the array
            table.remove(bulletNotesArray, GetSmallerInArray(bulletNotesArray, getSongPosition()));
        end
        -- adding shot ray
        triggerEvent('Add Shot Ray', '', '');

        -- Gets what sing animation Hank is currently on
        local curAnim = tostring(getProperty('dad.animation.curAnim.name'));

        local singLEFT = curAnim:startswith('singLEFT');
        local singRIGHT = curAnim:startswith('singRIGHT');
        local singUP = curAnim:startswith('singUP');
        local singDOWN = curAnim:startswith('singDOWN');

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