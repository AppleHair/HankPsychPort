
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
    -- string.sub() explanation: https://www.lua.org/pil/20.html#:~:text=The%20call-,string.sub,-(s%2Ci%2Cj
    -- # means the length of the array or string (table)
    return self:sub(1, #start) == start;
end

-- stores all the Bullet notes' strum time
-- this is being set later
local bulletNotesArray = {};

-- stores the x and y offsets of the shot ray
local shotRayPos = {300, 425};

function onCreatePost()
    -- adding the required script
    addLuaScript('custom_events/Shot Ray Effect', true);

    -- setting the shot ray position
    shotRayPos[1] = defaultOpponentX + shotRayPos[1];
    shotRayPos[2] = defaultOpponentY + shotRayPos[2];
    triggerEvent('Set Shot Ray Pos', shotRayPos[1], shotRayPos[2]);

    -- getting Bullet notes' strum time
    for i = 0, getProperty('unspawnNotes.length')-1 do
        -- we check if the note is an Bullet Note
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' then
            -- we add the strum time to the array
            table.insert(bulletNotesArray, getPropertyFromGroup('unspawnNotes', i, 'strumTime'));
        end
    end

    -- version = v0.x.y + 𝗨𝗠𝗠 0.z
    runningUMM = version:find("UMM") ~= nil;
end


local shootAgainNextFrame = false;
                ---Trying to override a sing animation with a shoot animation - Part 2---
-- Ok, so there was another problem. The way iteration works in the ForEachAlive method is just
-- like a for loop behind the scenes, which means removing an item from the array in the middle of
-- the iteration results in a "skip"-the item will be removed, the next item will move to the index
-- of the item that was just removed, and when the ForEachAlive function will try to continue to the next
-- item, it'll increase the index counter and check the item on that index, thus skipping the item that just
-- moved to the previous index as a result of the removal of the item that was there in the first place.

-- THIS IS EXACTLY WHAT HAPPENS ON THE UPDATE FUNCTION WHEN THE NOTES ARE BEING ITERATED ON PLAYSTATE,
-- and as a result, when there are several notes which need to appear at the same time, and some of them are being hit,
-- EVERY SECOND HIT NOTE WILL ONLY BE CHECKED AT THE NEXT FRAME, and if more than 1 hit note will stay
-- for the next frame, THE SAME PRINCIPLE WILL APPLY.

-- This happpens when hank hits a double note with a bullet note at the same time, and as a result,
-- the shoot animation overrode the sing animation on the first frame, but on the next frame, the second note
-- that hank needed to hit was checked, and as a result, the sing animation for that note played and overrode
-- the shoot animation. So now I check every time I play the shoot animation if there are still opponent
-- notes that should have already been checked, and use this shootAgainNextFrame variable to make the shoot
-- animation play on the next frame, overriding every sing animation on every relevant frame.
-- GOSH I'M SO HAPPY I'M FINALLY OVER ALL THIS SHIT!!!

function onUpdatePost(elapsed)

                    -- Hank shoot animation section --

    local prevSongPosition = getSongPosition() - getPropertyFromClass('flixel.FlxG', 'elapsed') * 1000;
                    ---Trying to override a sing animation with a shoot animation - Part 1---
    -- Ok, so I looked at the source code, and it turns out that because the song position is being updated
    -- on PlayState's update function, and the notes' update functions, which update thair wasGoodHit value and such
    -- in relation to the song position, only happen after PlayState's update function, every check for values 
    -- like wasGoodHit in notes in PlayState's update function are in relation to the previous song position,
    -- AND THAT'S WHY MY SHOOT ANIMAITIONS WERE GETTING OVERRIDDEN BY THE NORMAL SING ANIMATIONS! 
    -- BECAUSE THEY WERE ONE FUCKING FRAME EARLY!!!
    -- ...
    -- Psych engine lua is so easy, am I right?

    -- checks if a bullet note passed
    if getSmallerInArray(bulletNotesArray, prevSongPosition) ~= nil or shootAgainNextFrame then
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
            triggerEvent('Set Shot Ray Pos', shotRayPos[1] - 50 , shotRayPos[2] + 10);
		elseif singRIGHT then
            triggerEvent('Play Animation', 'shootRIGHT', 'dad');
            triggerEvent('Set Shot Ray Pos', shotRayPos[1] + 75, shotRayPos[2] + 25);
		elseif singDOWN then
            triggerEvent('Play Animation', 'shootDOWN', 'dad');
            triggerEvent('Set Shot Ray Pos', shotRayPos[1] + 50, shotRayPos[2] + 50);
		else-- that's why we don't need to check for singUP
            triggerEvent('Play Animation', 'shootUP', 'dad');
            triggerEvent('Set Shot Ray Pos', shotRayPos[1], shotRayPos[2]);
		end

        -- adding shot ray
        triggerEvent('Add Shot Ray', '', '');

        -- shacking camera
        cameraShake('game', 0.0075, 0.07);

        -- if the condition below is false,
        -- we shouldn't play the shoot animation again
        shootAgainNextFrame = false;

        for i = 0, getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', i, 'strumTime') <= prevSongPosition and 
                (not (getPropertyFromGroup('notes', i, 'mustPress') or getPropertyFromGroup('notes', i, 'noAnimation'))) then
                shootAgainNextFrame = true;
                break;
            end
        end
    end

    -- UMM has different conditions for
    -- the purpose of the code ahead
    if runningUMM then
        return;
    end

    -- if the player just pressed backspace
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then
        -- make hank do the hey animation (easter egg)
        triggerEvent('Play Animation', 'hey', 'dad');
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

-- I see a lot of people who make separate sprites for character animations which
-- shouldn't be followed by the idle animation. This can cause lag problems if not done
-- right (without the alpha = 0.00001 thing), uses more RAM then It needs to 
-- (because of all the FlxSprite object that are created) and makes your code unorganized.
-- There are also people who make separate characters, which is better performance wise,
-- but worse RAM wise, because the objects of the Character class are MUCH heavier.

-- The code above reaches the same goal, but without making any extra 
-- sprites or characters. just one character for all of the animations.