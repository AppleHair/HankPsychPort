
--[[
    Checks if a string starts with a curtain
    sequence of characters

    start - A string value of the sequence of characters
            that needs to be checked from the start
--]]
-- this function is being added to the string library/module
function string:startswith(start)
    -- string.sub() explanation: https://www.lua.org/pil/20.html#:~:text=The%20call-,string.sub,-(s%2Ci%2Cj
    -- # - the length of an table(array) / string

--"type 'string|number' doesn't match type 'string'" what an idiot...
---@diagnostic disable-next-line: param-type-mismatch 
    return self:sub(1, #start) == start;
end

-- stores the x and y offsets of the shot ray
local shotRayPos = {300, 425};

function onCreatePost()
    -- adding the required script
    addLuaScript('custom_events/Shot Ray Effect', true);

    -- setting the shot ray position
    shotRayPos[1] = defaultOpponentX + shotRayPos[1];
    shotRayPos[2] = defaultOpponentY + shotRayPos[2];
    triggerEvent('Set Shot Ray Pos', shotRayPos[1], shotRayPos[2]);

    -- onlinePlay = true | false
    runningUMM = onlinePlay ~= nil;
end

function onUpdatePost(elapsed)

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
    elseif name == "Shoot Anim Time" then
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