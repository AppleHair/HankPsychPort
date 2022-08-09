
--[[
	takes ARGB color values
	and turns them into
	HEX 0xAARRGGBB format.

	a - alpha value

	r - red value

	g - green value

	b - blue value
--]]
local function ARGBtoHEX(a, r, g, b)
	return string.format("0x%02x%02x%02x%02x", a, r, g, b);
end


function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' then

			-- no sustain bullet notes allowed!
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') or (not getPropertyFromGroup('unspawnNotes', i, 'mustPress')) then
				removeFromGroup('unspawnNotes', i);
				break;
			end
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'BulletNotes'); -- Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.8);
			
			
									-- color calibrations
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0 --[[ / 360   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', 0 --[[ / 100   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0 --[[ / 100   if you actually want to change it]]);
		end

		precacheImage('BulletNotes');
	end
end


local healthDrain = 0;
function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Bullet Note' then
		-- health -= 1 , but with drain
		healthDrain = healthDrain + 1;
	end
end


-- represents the x value of the
-- mathematical function that we use
-- to change the alpha value of the right
-- side of the health bar
local alphaFuncX = 0;
function onUpdate(elapsed)
	-- the health Drain itself
	if healthDrain > 0 then
		healthDrain = healthDrain - elapsed * 0.3;
		setProperty('health', getProperty('health') - elapsed * 0.3);


		-- getting the color arrays
		local dadColor = getProperty('dad.healthColorArray');
		local bfColor = getProperty('boyfriend.healthColorArray');

		-- increasing the x value
		alphaFuncX = alphaFuncX + elapsed;

		-- f(x) = |sin(π∙x)| ∙ 255
		-- local bfAlpha = f(x)
		local bfAlpha = math.abs(math.sin(math.pi * alphaFuncX)) * 255;
		
		-- Changing the health bar's color.
		-- The right side of the bar will flash in 
		-- the color of the left side of the bar
		setHealthBarColors(ARGBtoHEX(255, dadColor[1], dadColor[2], dadColor[3]),
			ARGBtoHEX(bfAlpha, bfColor[1], bfColor[2], bfColor[3]));

		if healthDrain < 0 then
			healthDrain = 0;
			alphaFuncX = 0;
			runHaxeCode([[
				game.reloadHealthBarColors();
			]]);
		end
	end
end

-----------------------------------------------------------------------
--  Health Drain code was made by Shadow Mario for Hank Reanimated.
--  It's not that much, but I'll credit him for this anyway.
--  https://gamebanana.com/mods/328455
-----------------------------------------------------------------------