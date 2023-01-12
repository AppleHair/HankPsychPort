
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
	-- string.format explanation: https://www.lua.org/pil/20.html#:~:text=The%20function-,string.format,-is%20a%20powerful
	return string.format("0x%02x%02x%02x%02x", a, r, g, b);
end


function onCreate()

	-- unlike the fire notes, here I don't load the 
	-- sprites early, because they are very small, 
	-- they don't cause lag (maybe on weaker computer they do, but they are not worth...) 
	-- and they are not worth extra RAM usage (the extra RAM usage comes
	-- from the new FlxSprite object we create to make the sprites load early).

	for i = getProperty('unspawnNotes.length')-1, 0, -1 do
		-- checks if the note is a bullet note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' then

			-- no sustain bullet notes allowed! + no opponent bullet notes allowed!
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') or (not getPropertyFromGroup('unspawnNotes', i, 'mustPress')) then
				removeFromGroup('unspawnNotes', i);
			else
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'BulletNotes'); -- we change the texture
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true); -- we make the note a no animation note
				setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true); -- we make the note have no miss animation
				setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.8); -- we make the health decrease more if you miss the note
				
				
										-- note color calibrations --
				setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0 --[[ / 360   if you actually want to change it]]);
				setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', 0 --[[ / 100   if you actually want to change it]]);
				setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0 --[[ / 100   if you actually want to change it]]);
			end
		end

		precacheImage('BulletNotes');
	end
end

-- this variable determines how much health
-- is being drained
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
		-- we decrease healthDrain and PlayState.instance.health by 0.3 every second
		healthDrain = healthDrain - elapsed * 0.3;
		setProperty('health', getProperty('health') - elapsed * 0.3);


		-- getting the color arrays
		local dadColor = getProperty('dad.healthColorArray');
		local bfColor = getProperty('boyfriend.healthColorArray');

		-- increasing the x value
		alphaFuncX = alphaFuncX + elapsed;

		-- 		f(x) = |sin(π∙x)| ∙ 255
		--  		       ↓
		-- 		  local bfAlpha = f(x)
		local bfAlpha = math.abs(math.sin(math.pi * alphaFuncX)) * 255;
		-- Mathematical functions are very useful for programming guys!
		-- Go learn some math!
		
		-- Changing the health bar's color.
		-- The right side of the bar will flash in 
		-- the color of the left side of the bar
		setHealthBarColors(ARGBtoHEX(255, dadColor[1], dadColor[2], dadColor[3]),
			ARGBtoHEX(bfAlpha, bfColor[1], bfColor[2], bfColor[3]));

		if healthDrain <= 0 then
			-- if healthDrain passed 0, then
			-- the health drain will stop
			healthDrain = 0;
			alphaFuncX = 0;
			runHaxeCode([[
				game.reloadHealthBarColors();
			]]);
		end
	end
end