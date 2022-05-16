local strings = {'IMPROBABLE','HANK!!!','MADNESS',"WHO'S THAT??",'INTERRUPTION','FIGHT ME','INVALID','CORRECTION','CLOWN'};
local minY = 200;
local maxY = 400;

local minX = -200;
local maxX = 200;


local doTheThing = false;

-- Event notes hooks
function onEvent(name, value1, value2)
    if name == 'Start Tricky Static' then
		doTheThing = true;
    end
    if name == 'Stop Tricky Static' and doTheThing then
        doTheThing = false;
    end
end

-- The randomizer:
function onStepHit()
	if doTheThing and getRandomBool(7) then
        triggerEvent('Do a static', strings[getRandomInt(1, table.getn(strings))], 
		tostring(getRandomInt(minX, maxX)) .. ', ' .. tostring(getRandomInt(minY, maxY)));
    end
end