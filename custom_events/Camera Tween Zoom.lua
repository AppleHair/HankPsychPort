function split(s, delimiter)
    result = {};
    -- go learn stuff: https://www.ibm.com/docs/en/ias?topic=manipulation-stringgmatch-s-pattern#:~:text=Product%20list-,string.gmatch%20(s%2C%20pattern),-Last%20Updated%3A%202021
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function trim(s)
    -- go learn stuff: https://www.lua.org/pil/20.1.html#:~:text=The-,string.gsub,-function%20has%20three
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
-- go learn string patterns: https://www.lua.org/pil/20.2.html

-- this variable stores the target zoom and the duration that is required for the tween
local tarAndDur;
function onEvent(name, value1, value2)
	if name == 'Camera Tween Zoom' and value1 ~= '' and value2 ~= '' then
        -- we cancel the current camera zoom tween if there is one
        cancelTween('ZoomEvent');

        -- we split the string into an array of strings
		tarAndDur = split(trim(value1) , ',');
        -- we do the tween
		doTweenZoom('ZoomEvent', 'camGame', tonumber(tarAndDur[1]), tonumber(tarAndDur[2]), tostring(value2));
        -- we set isCameraOnForcedPos to the required zoom value
		setProperty('defaultCamZoom', tonumber(tarAndDur[1]));
	end
end


-- this event helped me a lot  with getting 
-- the camera zoom stuff right and keep it in
-- sync with the camera movements. you can use
-- this script in your own port or mod if you
-- want to (you don't need to credit me).