function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local XYAndDir;
function onEvent(name, value1, value2)
	if name == 'Camera Tween Pos' then
		XYAndDir = Split(tostring(value1), ', ');
		doTweenX('CameraEventX', 'camFollowPos', tonumber(XYAndDir[1]), tonumber(XYAndDir[3]), tostring(value2));
		doTweenY('CameraEventY', 'camFollowPos', tonumber(XYAndDir[2]), tonumber(XYAndDir[3]), tostring(value2));
        setProperty('isCameraOnForcedPos', true);
	end
end

function onTweenCompleted(tag)
	if tag == 'CameraEventX' then
        setProperty('camFollow.x', tonumber(XYAndDir[1]));
    end
    if tag == 'CameraEventY' then
        setProperty('camFollow.y', tonumber(XYAndDir[2]));
    end
end