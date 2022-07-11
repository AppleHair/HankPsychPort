function onEvent(name, value1, value2)
	if name == 'Play Sound' and value1 ~= '' and value2 ~= '' then
		playSound(value1, tonumber(value2));
	end
end