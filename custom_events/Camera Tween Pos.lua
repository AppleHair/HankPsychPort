local function split(s, delimiter)
    result = {};
    -- go learn stuff: https://www.ibm.com/docs/en/ias?topic=manipulation-stringgmatch-s-pattern#:~:text=Product%20list-,string.gmatch%20(s%2C%20pattern),-Last%20Updated%3A%202021
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function trim(s)
    -- go learn stuff: https://www.lua.org/pil/20.1.html#:~:text=The-,string.gsub,-function%20has%20three
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
-- go learn string patterns: https://www.lua.org/pil/20.2.html

-- this variable stores the x position, y position
-- and duration that is required for the tween
local XYAndDur;
function onEvent(name, value1, value2)
	if name == 'Camera Tween Pos' then
        if value1 == '' and value2 == '' then
            setProperty('isCameraOnForcedPos', false);
            return;
        end
        -- we cancel the current camera position tween if there is one
        cancelTween('CameraEventX');
        cancelTween('CameraEventY');

        -- we split the string into an array of strings
        XYAndDur = split(trim(value1), ',');
        -- we do the tweens
        doTweenX('CameraEventX', 'camFollowPos', tonumber(XYAndDur[1]), tonumber(XYAndDur[3]), value2);
        doTweenY('CameraEventY', 'camFollowPos', tonumber(XYAndDur[2]), tonumber(XYAndDur[3]), value2);
        -- we set isCameraOnForcedPos to true
        setProperty('isCameraOnForcedPos', true);
    end
end

function onTweenCompleted(tag)
    -- we set camFollow's positions to the required positions when the tween ends
	if tag == 'CameraEventX' then
        setProperty('camFollow.x', tonumber(XYAndDur[1]));
    end
    if tag == 'CameraEventY' then
        setProperty('camFollow.y', tonumber(XYAndDur[2]));
    end
end


-- this event helped me a lot  with getting 
-- the camera movement stuff right. you can use
-- this script in your own port or mod if you
-- want to (you don't need to credit me).