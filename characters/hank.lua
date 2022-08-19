
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
-- this function is being added to the string library/module
function string:startswith(start)
    -- go learn stuff: https://www.lua.org/pil/20.html#:~:text=The%20call-,string.sub,-(s%2Ci%2Cj
    -- # means the length of the array or string (table)
    return self:sub(1, #start) == start;
end

-- stores all the Bullet notes' strum time
-- this is being set later
local bulletNotesArray = {};

-- stores the x and y positions of the shot ray
local shotRayPos = {250, 350};



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

function onUpdatePost(elapsed)
    -- character must be Hank!!
    if dadName ~= 'hank' then
        return;
    end

                    -- Hank shoot animation section --

    local prevSongPosition = getSongPosition() - getPropertyFromClass('flixel.FlxG', 'elapsed') * 1000;
    -- Ok, so I looked at the source code, and it turns out that because the song position is being updated
    -- on PlayState's update function, but the notes' update functions, which update thair wasGoodHit value and such
    -- in relation to the song position, only happen after PlayState's update function, every check for values 
    -- like wasGoodHit in notes in PlayState's update function are in relation to the previous song position,
    -- AND THAT'S WHY MY SHOOT ANIMAITIONS WERE GETTING CANCELED BY THE NORMAL SING ANIMATIONS! 
    -- BECAUSE THEY WERE ONE FUCKING FRAME EARLY!!!
    -- ...
    -- psych engine lua is so easy, right?

    -- checks if a bullet note passed
    if getSmallerInArray(bulletNotesArray, prevSongPosition) ~= nil then
        -- local strumTime = bulletNotesArray[getSmallerInArray(bulletNotesArray, prevSongPosition)];
        while getSmallerInArray(bulletNotesArray, prevSongPosition) ~= nil do
            -- removing the strum time from the array
            table.remove(bulletNotesArray, getSmallerInArray(bulletNotesArray, prevSongPosition));
        end

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
            triggerEvent('Set Shot Ray Pos', shotRayPos[1], shotRayPos[2] + 10);
		elseif singRIGHT then
            triggerEvent('Play Animation', 'shootRIGHT', 'dad');
            triggerEvent('Set Shot Ray Pos', shotRayPos[1] + 20, shotRayPos[2] + 10);
		elseif singDOWN then
            triggerEvent('Play Animation', 'shootDOWN', 'dad');
            triggerEvent('Set Shot Ray Pos', shotRayPos[1], shotRayPos[2] + 10);
		else-- that's why we don't need to check for singUP
            triggerEvent('Play Animation', 'shootUP', 'dad');
            triggerEvent('Set Shot Ray Pos', shotRayPos[1], shotRayPos[2]);
		end

        -- adding shot ray
        triggerEvent('Add Shot Ray', '', '');

        -- shacking camera
        cameraShake('game', 0.0075, 0.07);
    end
end

-------------------------------------------------------------------
-- Animation Event Related Stuff
-------------------------------------------------------------------
function onEvent(name, val1, val2)
    -- we check if an event makes the opponent play the scaredShoot or the getReady animations
    if name == 'Play Animation' and val2 == 'dad' and (val1 == 'scaredShoot' or val1 == 'getReady') then
        -- we make the character stunned to prevent him from playing the idle animation
        setProperty('dad.stunned', true);
        -- we set specialAnim to false to prevent him from playing the idle animation anyway
        setProperty('dad.specialAnim', false);
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    -- we check if the opponent is stunned
	if getProperty('dad.stunned') then
        -- we set stunned to false to let him play the idle animation
        setProperty('dad.stunned', false);
    end
end

-- I see a lot of people that make separate sprites for character animations that
-- need to not convert to the idle animation. This can cause lag problems if not done
-- right (without the alpha = 0.00001 thing), uses more RAM then It needs to 
-- (because of all the FlxSprite object that are created) and makes your code unorganized.
-- There are also people that make separate characters, which is better performance wise,
-- but worse RAM wise. The code above reaches the same goal, but without making any extra 
-- sprites or characters. just one character for all of the animations.