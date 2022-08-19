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

-- the defult string array
local strings = {'IMPROBABLE','HANK!!!','MADNESS',"WHO'S THAT??",'INTERRUPTION','FIGHT ME','INVALID','CORRECTION','CLOWN'};

-- the max and min x and y positions for
-- the Tricky text
local minY = 200;
local maxY = 400;
local minX = -200;
local maxX = 200;

-- the chance of the static and text appearing
-- for every step
local chance = 7;

-- determines if random Tricky static and text
-- should be generated
local doTheThing = false;

function onCreate()
    -- we add the Tricky static event script
    addLuaScript('custom_events/Do a static', true);
end

-- Event notes hooks
function onEvent(name, value1, value2)
    if name == 'Start Tricky Static' then
        if value1 ~= '' then
            -- we split the string into an array of strings
            strings = split(trim(value1), ',');
        end
        if value2 ~= '' then
            -- value 2 will become the chance
            chance = tonumber(value2);
        end
        -- we now need to generate random Tricky static and text
        doTheThing = true;
    end
    if name == 'Stop Tricky Static' and doTheThing then
        -- we now don't need to generate random Tricky static and text
        doTheThing = false;
    end
end

-- The randomizer:
function onStepHit()
    -- we check if we need to generate random tricky static
    -- and the random boolean value we get is true
	if doTheThing and getRandomBool(chance) then
        triggerEvent('Do a static', strings[getRandomInt(1, #strings)],
		    tostring(getRandomInt(minX, maxX)) .. ',' .. tostring(getRandomInt(minY, maxY)));
    end
end