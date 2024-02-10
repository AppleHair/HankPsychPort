local function split(s, delimiter)
    local result = {};
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

-- the default clown phrases array
local clownPhrases = {'IMPROBABLE','HANK!!!','MADNESS',"WHO'S THAT??",'INTERRUPTION','FIGHT ME','INVALID','CORRECTION','CLOWN','OMFG!!!'};

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
            -- value 1 will become the chance
            chance = (tonumber(value1) ~= nil and tonumber(value1) or 0);
        end
        if value2 ~= '' then
            -- value 2 will be a new phrase
            table.insert(clownPhrases, value2);
        end
        -- we now need to generate random Tricky static and text
        doTheThing = true;
    elseif name == 'Stop Tricky Static' and doTheThing then
        -- we now don't need to generate random Tricky static and text
        doTheThing = false;
    end
end

-- The randomizer:
function onStepHit()
    -- we check if we need to generate random tricky static
    -- and the random boolean value we get is true
	if doTheThing and getRandomBool(chance) then
        triggerEvent('Do a static', clownPhrases[getRandomInt(1, #clownPhrases)], 'random,random');
    end
end