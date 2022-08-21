local function trim(s)
    -- go learn stuff: https://www.lua.org/pil/20.1.html#:~:text=The-,string.gsub,-function%20has%20three
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
-- go learn string patterns: https://www.lua.org/pil/20.2.html

function onEvent(name, value1, value2)
	if name == 'Play Sound' and value1 ~= '' and value2 ~= '' then
		playSound(trim(value1), tonumber(value2));
	end
end