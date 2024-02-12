
-- short for linear interpolation
local function lerp(a, b, ratio)
    return a + (b - a) * ratio;
end

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

--[[
    returns the index of the first member
    from a curtain array that is smaller
    then a curtain value. if the array doesn't
    have a member that is smaller than the
    value, the function will return nil.

    arr - Array to check
    value - Value to check
--]]
local function getSmallerInArray(arr, value)
	for i,v in ipairs(arr) do 
		if v <= value then
            return i;
        end
	end
	return nil;
end

-- stores all the Bullet notes' strum time
-- this is being set later
local bulletNotesArray = {};

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
	
				-- disables the coloring of the bullet notes
				setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false);
				-- makes the note splashes use the default colors
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.useGlobalShader', true);
				-- we add the strum time to the array
				table.insert(bulletNotesArray, getPropertyFromGroup('unspawnNotes', i, 'strumTime'));
			end
		end
	end

	precacheImage('BulletNotes');
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

local shootAgainNextFrame = false;
                ---Trying to override a sing animation with a shoot animation - Part 2---
-- Ok, so there was another problem. The way iteration works in the ForEachAlive method is just
-- like a for loop behind the scenes, which means removing an item from the array in the middle of
-- the iteration results in a "skip"-the item will be removed, the next item will move to the index
-- of the item that was just removed, and when the ForEachAlive function will try to continue to the next
-- item, it'll increase the index counter and check the item on that index, thus skipping the item that just
-- moved to the previous index as a result of the removal of the item that was there in the first place.

-- THIS IS EXACTLY WHAT HAPPENS ON THE UPDATE FUNCTION WHEN THE NOTES ARE BEING ITERATED ON PLAYSTATE,
-- and as a result, when there are several notes which need to appear at the same time, and some of them are being hit,
-- EVERY SECOND HIT NOTE WILL ONLY BE CHECKED AT THE NEXT FRAME, and if more than 1 hit note will stay
-- for the next frame, THE SAME PRINCIPLE WILL APPLY.

-- This happpens when hank hits a double note with a bullet note at the same time, and as a result,
-- the shoot animation overrode the sing animation on the first frame, but on the next frame, the second note
-- that hank needed to hit was checked, and as a result, the sing animation for that note played and overrode
-- the shoot animation. So now I check every time I play the shoot animation if there are still opponent
-- notes that should have already been checked, and use this shootAgainNextFrame variable to make the shoot
-- animation play on the next frame, overriding every sing animation on every relevant frame.
-- GOSH I'M SO HAPPY I'M FINALLY OVER ALL THIS SHIT!!!

function onUpdatePost(elapsed)
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

		-- f(x) = (cos((x + 1)∙π) + 1) : 2
		--  		      ↓
		-- 	     local bfAlpha = f(x)
		local bfAlpha = (math.cos((alphaFuncX + 1) * math.pi) + 1) / 2;
		-- Mathematical functions are very useful for programming guys!
		-- Go learn some math!

		-- we lerp between every
		-- RGB value of the two
		-- colors. using bfAlpha
		-- as a ratio.
		for i = 1, 3 do
			bfColor[i] = lerp(bfColor[i], dadColor[i], bfAlpha);
		end
		
		-- Changing the health bar's color.
		-- The right side of the bar will flash in 
		-- the color of the left side of the bar
		setHealthBarColors(ARGBtoHEX(255, dadColor[1], dadColor[2], dadColor[3]),
			ARGBtoHEX(bfAlpha * 255, bfColor[1], bfColor[2], bfColor[3]));

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
---------------------------------------------------
        --Bullet Note Time Events ("Signals")--
---------------------------------------------------
	local prevSongPosition = getSongPosition() - getPropertyFromClass('flixel.FlxG', 'elapsed') * 1000;
                    ---Trying to override a sing animation with a shoot animation - Part 1---
    -- Ok, so I looked at the source code, and it turns out that because the song position is being updated
    -- on PlayState's update function, and the notes' update functions, which update thair wasGoodHit value and such
    -- in relation to the song position, only happen after PlayState's update function, every check for values 
    -- like wasGoodHit in notes in PlayState's update function are in relation to the previous song position,
    -- AND THAT'S WHY MY SHOOT ANIMAITIONS WERE GETTING OVERRIDDEN BY THE NORMAL SING ANIMATIONS! 
    -- BECAUSE THEY WERE ONE FUCKING FRAME EARLY!!!
    -- ...
    -- Psych engine lua is so easy, am I right?

	-- checks if a bullet note passed
    if getSmallerInArray(bulletNotesArray, prevSongPosition) ~= nil or shootAgainNextFrame then
        -- local strumTime = bulletNotesArray[getSmallerInArray(bulletNotesArray, prevSongPosition)];
        while getSmallerInArray(bulletNotesArray, prevSongPosition) ~= nil do
            -- removing the strum time from the array
            table.remove(bulletNotesArray, getSmallerInArray(bulletNotesArray, prevSongPosition));
        end

		if not shootAgainNextFrame then
			-- play shot sound
			-- playSound('hankshoot', 1);
			-- if you want to do something
			-- when a bullet note is hit,
			-- and don't need to override
			-- a sing animation, refer to
			-- This event (always gets called
			-- once per bullet note strumtime)
			triggerEvent("Bullet Note Time");
			-- shake camera
			cameraShake('game', 0.01, 0.07);
		end
		-- if you want to override the
		-- current sing animation with
		-- another animation, refer to
		-- This event (might get called
		-- across multiple frames)
		triggerEvent("Shoot Anim Time");

		-- if the condition below is false,
        -- we shouldn't play the shoot animation again
        shootAgainNextFrame = false;

        for i = 0, getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', i, 'strumTime') <= prevSongPosition and 
                (not (getPropertyFromGroup('notes', i, 'mustPress') or getPropertyFromGroup('notes', i, 'noAnimation'))) then
                shootAgainNextFrame = true;
                break;
            end
        end
	end
end