local function iNeedToWriteThisTwiceForOnlinePlay()

    -- we remove every kind of camera movement events
    -- from the song in order to avoid weird stage problems,
    -- and we also remove alt idle events if the character
    -- doesn't have the required animations.
    for i = getProperty('eventNotes.length')-1, 0, -1 do
		if (getPropertyFromGroup('eventNotes', i, 'event') == "Camera Tween Pos" and inCustomStage) or
          (getPropertyFromGroup('eventNotes', i, 'event') == "Camera Tween Zoom" and inCustomStage) or
          (getPropertyFromGroup('eventNotes', i, 'event') == "Camera Follow Pos" and inCustomStage) or
          (getPropertyFromGroup('eventNotes', i, 'event') == "Alt Idle Animation" and (not hankScriptRunning)) or
          (getPropertyFromGroup('eventNotes', i, 'strumTime') >= 99237.8048780486 and inCustomStage) then
            removeFromGroup('eventNotes', i);
		end
	end
end

function onCreatePost()
    -- onlinePlay = true | false
    runningUMM = onlinePlay ~= nil;
    if not runningUMM then
        return;
    end
----------------------------------------------------------------------------------------------------------------------
		-- The Unnamed Multiplayer Mod Handler --
----------------------------------------------------------------------------------------------------------------------

    bfScriptRunning = isRunning('characters/bf');
    
    hankScriptRunning = isRunning('characters/hank');

    -- the next part is for hosters only!
    if onlinePlay and (not Hosting) then
        return;
    end

    -- getTextFromFile doesn't work properly on the other end,
    -- so now I need to write my code in this weird kind of
    -- structure, that makes it look funny.
    inCustomStage = getTextFromFile("data/"..songPath.."/"..songPath..difficultyPath..".json"):
    find("\"stage\": \""..curStage.."\"") == nil;

    -- if it's true and we are in onlinePlay
    if onlinePlay and inCustomStage then
        -- send a message to the server
        send("inCustomStage");
    end

    -- we do some important checks (see implumentation)
    iNeedToWriteThisTwiceForOnlinePlay();
    
end

function onReceive(message)
    -- we receive the message in the other end
    if message == "inCustomStage" then
        -- we set it to true
        inCustomStage = true;

        -- we do some important checks AGAIN (see implumentation)
        iNeedToWriteThisTwiceForOnlinePlay();

    end
end

function onUpdate(elapsed)
    if not runningUMM then
        return;
    end

    if not leftSide then
        -- if the player just pressed space
        if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
            -- make boyfriend do the hey animation
            triggerEvent('Play Animation', 'hey', 'bf');
        end
    end

    if leftSide then
        -- if the player just pressed space
        if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
            -- make boyfriend do the hey animation
            triggerEvent('Play Animation', 'hey', 'dad');
        end
    end
end