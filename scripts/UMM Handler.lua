function onCreatePost()
    if version:find("UMM") == nil then
        return;
    end
    if getTextFromFile("data/"..songPath.."/"..songPath.."-"..difficultyPath..".json"):find("\"stage\": \""..curStage.."\"") ~= nil then
        return;
    end
    for i = getProperty('eventNotes.length')-1, 0, -1 do
		if getPropertyFromGroup('eventNotes', i, 'event') == "Camera Tween Pos" or
          getPropertyFromGroup('eventNotes', i, 'event') == "Camera Tween Zoom" or
          getPropertyFromGroup('eventNotes', i, 'event') == "Camera Follow Pos" then
            removeFromGroup('eventNotes', i);
		end
	end
end