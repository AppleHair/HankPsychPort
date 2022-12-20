local function split(s, delimiter)
    result = {};
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

-- this variable stores the current stage's default zoom value
local originalDefaultZoom;
function onCreatePost()
    -- we set originalDefaultZoom to the original defaultCamZoom value
    originalDefaultZoom = getProperty('defaultCamZoom');
end

function onEvent(name, value1, value2)
	if name == 'Camera Tween Zoom' then
        -- we cancel the current camera zoom tween if there is one
        cancelTween('ZoomEvent');
        
        -- if there are no values, we set camZooming to true,
        -- to make the camera zoom naturally again, and we
        -- also set defaultCamZoom back to it's original value.
        if value1 == '' and value2 == '' then
            setProperty('camZooming', true);
            setProperty('defaultCamZoom', originalDefaultZoom);
            return;
        end

        -- we split the string into an array of strings
        -- that stores the target zoom and the duration that is required for the tween
		local tarAndDur = split(trim(value1) , ',');
        -- we do the tween
		doTweenZoom('ZoomEvent', 'camGame', tonumber(tarAndDur[1]), tonumber(tarAndDur[2]), tostring(value2));
        -- we set defaultCamZoom to the required zoom value
        setProperty('defaultCamZoom', tonumber(tarAndDur[1]));
        -- we set camZooming to false, so the zoom tween won't be interupted 
        setProperty('camZooming', false);
	end
end

function onTweenCompleted(tag)
    if getProperty('camZooming') == true then return; end
	if tag == 'ZoomEvent' then
        -- we set camZooming to true, to make the camera zoom naturally again
        setProperty('camZooming', true);
    end
end

-- this event helped me a lot  with getting 
-- the camera zoom stuff right and keep it in
-- sync with the camera movements. you can use
-- this script in your own port or mod if you
-- want to (you don't need to credit me).