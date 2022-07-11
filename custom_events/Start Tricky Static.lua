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

local strings = {'IMPROBABLE','HANK!!!','MADNESS',"WHO'S THAT??",'INTERRUPTION','FIGHT ME','INVALID','CORRECTION','CLOWN'};
local minY = 200;
local maxY = 400;

local minX = -200;
local maxX = 200;

local chance = 7;

local doTheThing = false;

function onCreate()
    addLuaScript('custom_events/Do a static', true);
end

-- Event notes hooks
function onEvent(name, value1, value2)
    if name == 'Start Tricky Static' then
        if value1 ~= '' then
            strings = split(trim(value1), ',');
        end
        if value2 ~= '' then
            chance = tonumber(value2);
        end
        doTheThing = true;
    end
    if name == 'Stop Tricky Static' and doTheThing then
        doTheThing = false;
    end
end

-- The randomizer:
function onStepHit()
	  if doTheThing and getRandomBool(chance) then
        triggerEvent('Do a static', strings[getRandomInt(1, table.getn(strings))], 
		    tostring(getRandomInt(minX, maxX)) .. ', ' .. tostring(getRandomInt(minY, maxY)));
    end
end