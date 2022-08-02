
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
            table.insert(bulletNotesArray, getPropertyFromGroup('unspawnNotes', i, 'strumTime') + 10);
            -- So for some reason, the opponent always starts playing his sing animation ~2-9 milliseconds (I think)
            -- after the time he should, which makes the shoot animations get cancelled when they play in "the same time"
            -- as a sing animation, even though I put the code for the animation on 'onUpdatePost',
            -- which is being read after the sing animations are being played. I don't know what causes this,
            -- I don't know if the fix of making shoot animations play 10 milliseconds after they should will
            -- work for other people, but its not like this issue is too necessary for this demo,
            -- so I'll rack my brain over this after the demo.

            -- TODO: understand the source of this problem and make sure the solution will work for everyone.
        end
    end
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
        -- local singUP;
        local singRIGHT;
   
        curAnim = getProperty('dad.animation.curAnim.name');

        singLEFT = curAnim:startswith('singLEFT');
        singDOWN = curAnim:startswith('singDOWN');
        -- singUP = curAnim:startswith('singUP');
        singRIGHT = curAnim:startswith('singRIGHT');

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