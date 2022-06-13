function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function onEvent(name, value1, value2)
	if name == 'Camera Tween Zoom' and value1 ~= '' and value2 ~= '' then
		tarAndDur = Split(tostring(value1), ', ');
		doTweenZoom('ZoomEvent', 'camGame', tonumber(tarAndDur[1]), tonumber(tarAndDur[2]), tostring(value2));
		setProperty('defaultCamZoom', tonumber(tarAndDur[1]));
	end
end