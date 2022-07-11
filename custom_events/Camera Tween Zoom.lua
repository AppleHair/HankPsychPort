function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function trim(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end

local tarAndDur;
function onEvent(name, value1, value2)
	if name == 'Camera Tween Zoom' and value1 ~= '' and value2 ~= '' then
		tarAndDur = split(trim(value1) , ',');
		doTweenZoom('ZoomEvent', 'camGame', tonumber(tarAndDur[1]), tonumber(tarAndDur[2]), tostring(value2));
		setProperty('defaultCamZoom', tonumber(tarAndDur[1]));
	end
end