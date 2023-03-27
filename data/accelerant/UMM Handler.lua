
--[[
	Checks if a curtain value is
	in a curtain array

	arr - array to check in
	value - value to check
]]
local function isInArray(arr, value)
	for i=1, #arr do
		if arr[i] == value then
			return true;
		end
	end
	return false;
end

--[[
	Checks if a curtain character
    includes a curtain list of
    animations and returns a 
    boolean accordingly.

	arr - array of animation names to check
	char - name of character to check
]]
local function checkRequiredAnims(arr, char)
    local count = 0;
    local requiredAnims = arr;
    for i = 0, getProperty(char..".animationsArray.length") - 1 do
        if isInArray(requiredAnims, getProperty(char..".animationsArray["..i.."].anim")) then
            count = count + 1;
        end
    end
    return count == #requiredAnims;
end


function onCreatePost()
    if version:find("UMM") == nil then
        return;
    end
----------------------------------------------------------------------------------------------------------------------
		-- The Untitled Multiplayer Mod Handler --
----------------------------------------------------------------------------------------------------------------------

    --[[
        To use a custom P1 in this song properly,
        it needs to have the following animations:

        hey, dodge, hurt
    ]]
    if getProperty("boyfriend.Custom") or bfName ~= 'bf' then
        if checkRequiredAnims({"dodge", "hurt", "hey"},"boyfriend") then
            addLuaScript('characters/bf');
        end
    end

    local hankScriptRunning = false;
    --[[
        To use a custom P2 in this song properly,
        it needs to have the following animations:

        shootRIGHT, shootDOWN, shootUP, shootLEFT,
        hey, scaredShoot, idle-scared, getReady
    ]]
    if getProperty("dad.Custom") or dadName ~= 'hank' then 
        if checkRequiredAnims({"shootRIGHT", "shootDOWN", "shootUP", "shootLEFT", "hey", 
          "scaredShoot", "idle-scared", "getReady"}, "dad") then
            addLuaScript('characters/hank');
            hankScriptRunning = true;
        end
    end


    -- if a custom stage is used
    local inCustomStage = getTextFromFile("data/"..songPath.."/"..songPath.."-"..difficultyPath..".json"):find("\"stage\": \""..curStage.."\"") == nil;

    -- we remove every kind of camera movement events
    -- from the song in order to avoid weird stage problems
    for i = getProperty('eventNotes.length')-1, 0, -1 do
		if (getPropertyFromGroup('eventNotes', i, 'event') == "Camera Tween Pos" and inCustomStage) or
          (getPropertyFromGroup('eventNotes', i, 'event') == "Camera Tween Zoom" and inCustomStage) or
          (getPropertyFromGroup('eventNotes', i, 'event') == "Camera Follow Pos" and inCustomStage) or
          (getPropertyFromGroup('eventNotes', i, 'event') == "Alt Idle Animation" and (not hankScriptRunning)) then
            removeFromGroup('eventNotes', i);
		end
	end
end