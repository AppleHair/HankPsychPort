function onEvent(name, value1, value2)
	if name == 'Play Sound' then
		playSound(tostring(value1), tonumber(value2));
	end
end