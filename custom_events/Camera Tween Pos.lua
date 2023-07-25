local function split(s, delimiter)
    local result = {};
    -- string.gmatch() explanation: https://www.ibm.com/docs/en/ias?topic=manipulation-stringgmatch-s-pattern#:~:text=Product%20list-,string.gmatch%20(s%2C%20pattern),-Last%20Updated%3A%202021
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function trim(s)
    -- string.gsub() explanation: https://www.lua.org/pil/20.1.html#:~:text=The-,string.gsub,-function%20has%20three
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
-- string patterns explanation: https://www.lua.org/pil/20.2.html

local OnPsych06 = false;
local camPosProp;
function onCreate()
    OnPsych06 = version:find('^v?0%.6') ~= nil;
    camPosProp = (OnPsych06 and "camFollowPos" or "camGame.scroll");
end

-- this variable stores the x position, y position
-- and duration that is required for the tween
local XYAndDur;
function onEvent(name, value1, value2)
    if name == 'Camera Follow Pos' then
        -- we cancel the current camera position tween if there is one
        -- because we don't want the tween to interupt this other procedure
        -- of camera following.
        cancelTween('CameraEventX');
        cancelTween('CameraEventY');
        return;
    end
	if name == 'Camera Tween Pos' then
        -- we cancel the current camera position tween if there is one
        cancelTween('CameraEventX');
        cancelTween('CameraEventY');

        -- if there are no values, we set isCameraOnForcedPos to false
        -- and make the camera move naturally again 
        if value1 == '' and value2 == '' then
            setProperty('isCameraOnForcedPos', false);
            return;
        end

        -- we split the string into an array of strings
        XYAndDur = split(trim(value1), ',');
        -- we make sure they are numbers
        XYAndDur[1] = (tonumber(XYAndDur[1]) ~= nil and tonumber(XYAndDur[1]) or 0);
        XYAndDur[2] = (tonumber(XYAndDur[2]) ~= nil and tonumber(XYAndDur[2]) or 0);
        XYAndDur[3] = (tonumber(XYAndDur[3]) ~= nil and tonumber(XYAndDur[3]) or 0);

        -- we do the tweens
        doTweenX('CameraEventX', camPosProp, XYAndDur[1] - (OnPsych06 and 0 or (screenWidth / 2)), XYAndDur[3], value2);
        doTweenY('CameraEventY', camPosProp, XYAndDur[2] - (OnPsych06 and 0 or (screenHeight / 2)), XYAndDur[3], value2);
        -- we set isCameraOnForcedPos to true
        setProperty('isCameraOnForcedPos', true);
    end
end

function onTweenCompleted(tag)
    if getProperty('isCameraOnForcedPos') == false then return; end
    -- we set camFollow's positions to the required positions when the tween ends
	if tag == 'CameraEventX' then
        setProperty('camFollow.x', XYAndDur[1]);
    end
    if tag == 'CameraEventY' then
        setProperty('camFollow.y', XYAndDur[2]);
    end
end


-- this event helped me a lot  with getting 
-- the camera movement stuff right. you can use
-- this script in your own port or mod if you
-- want to (you don't need to credit me).