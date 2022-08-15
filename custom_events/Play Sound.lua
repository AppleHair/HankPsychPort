function trim(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end

function onEvent(name, value1, value2)
	if name == 'Play Sound' and value1 ~= '' and value2 ~= '' then
		playSound(trim(value1), tonumber(value2));
	end
end