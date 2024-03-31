
-- tells if the fire note
-- should be a halo note
-- (instakill on hit)
local halo = false;

-- Used to determine if the game
-- is in multiplayer mode on UMM,
-- and tell the script to balance
-- the halo note accordingly.
local balance = false;

function onCreatePost()

	-- toggles halo note if in the
	-- fucked difficulty. can be toggled earlier
	-- to prevent halo note on fucked difficulty
	if difficultyPath == "fucked" or difficultyPath == "unfair" then
		triggerEvent("Signal-Toggle Halo Note");
	end

	-- check if the game is in multiplayer mode
    balance = localPlay or onlinePlay;

	makeAnimatedLuaSprite('fireNote', (halo and 'Halo Note' or 'NOTE_fire'), 0, 0);
	addAnimationByPrefix('fireNote', 'red', 'red', 24, false);
	addAnimationByPrefix('fireNote', 'purple', 'purple', 24, false);
	addAnimationByPrefix('fireNote', 'green', 'green', 24, false);
	addAnimationByPrefix('fireNote', 'blue', 'blue', 24, false);
	setProperty('fireNote.alpha', 0.00001);
	addLuaSprite('fireNote', true);
	makeAnimatedLuaSprite('Smokey', 'Smoke', 0, 0);
	addAnimationByPrefix('Smokey', 'red1', 'note splash red 1', 24, false);
	addAnimationByPrefix('Smokey', 'purple1', 'note splash purple 1', 24, false);
	addAnimationByPrefix('Smokey', 'green1', 'note splash green 1', 24, false);
	addAnimationByPrefix('Smokey', 'blue1', 'note splash blue 1', 24, false);
	addAnimationByPrefix('Smokey', 'red2', 'note splash red 2', 24, false);
	addAnimationByPrefix('Smokey', 'purple2', 'note splash purple 2', 24, false);
	addAnimationByPrefix('Smokey', 'green2', 'note splash green 2', 24, false);
	addAnimationByPrefix('Smokey', 'blue2', 'note splash blue 2', 24, false);
	setProperty('Smokey.alpha', 0.00001);
	addLuaSprite('Smokey', true);
	-- I hate this, but it helps
	-- the sprites load without lag lmao.
	-- The way it works is that I set the
	-- alpha to 0.00001 (not 0 and not .visible = false), 
	-- and because of that the game engine thinks it needs to load the
	-- sprites into the stage, although you can't actually see
	-- them. Like that, I can load sprites early and avoid lag.
	-- It's very stupid, because we make a new FlxSprite object, that makes us use more RAM, to make this work,
	-- but it works really well and prevents serious lag, so it's worth it.


	for i = getProperty('unspawnNotes.length')-1, 0, -1 do
		-- checks if the note is a fire note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fire Note' then

			-- no sustain fire notes allowed!
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
				removeFromGroup('unspawnNotes', i);
			else
				setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true); -- we make the note have no miss animation
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); -- we make botplay and opponent not press this note
				setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true); -- we make hitting this note cause a miss
				setPropertyFromGroup('unspawnNotes', i, 'missHealth', ((halo and (not balance)) and 2 or 0.3)); -- we make the health decrease more if you miss(hit) the note
				setPropertyFromGroup('unspawnNotes', i, 'ratingDisabled', true); -- we make this note not make a pop-up rating thing 
				setPropertyFromGroup('unspawnNotes', i, 'lowPriority', true); -- we make the note low priority
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.disabled', false); -- we enable splash despite the prefs
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.texture', 'Smoke'); -- we change the splash texture
				setPropertyFromGroup('unspawnNotes', i, 'texture', (halo and 'Halo Note' or 'NOTE_fire')); -- we change the texture
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', (halo and -166.5 or -50));-- we set offsetX
				setPropertyFromGroup('unspawnNotes', i, 'offsetY', (halo and -66.44 or (downscroll and -195.34 or -57.44)));-- we set offsetY according to downscroll prefs
										-- in-line if moment --		  boolean        true      false
				
				-- disables the coloring of the fire notes
				setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false);

				-- disables the coloring of the fire note splashes
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.r', 0xFF0000);
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.g', 0x00FF00);
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.b', 0x0000FF);

				-- makes the fire note splashes opaque
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.a', 1);
			end
		end
	end

	-- precache stuff

	
	precacheImage('Smoke');
	if halo then
		precacheImage('Halo Note');
		precacheSound('death');
		return;
	end
	precacheImage('NOTE_fire');
	precacheSound('burnSound');
end

function onSpawnNote(id, noteData, noteType, isSustainNote)
	if downscroll and noteType == 'Fire Note' and (not halo) then

		-- we need to make the fire note flip vertically on down scroll
		-- (that's if you don't want the fire to go in the wrong direction)
		setPropertyFromGroup('notes', id, 'flipY', true);

		-- and because this vertical flip make the down notes up notes
		-- and the up notes down notes, we make one play the other's animation
		if noteData == 1 then
			runHaxeCode([[
				game.notes.members[]]..id..[[].animation.play('greenScroll');
			]])
		elseif noteData == 2 then
			runHaxeCode([[
				game.notes.members[]]..id..[[].animation.play('blueScroll');
			]])
		end
	end
end

-- An array of indexes of the current missed
-- fire notes' splashes on the grpNoteSplashes group.
local MissSplashIndex = {};

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' and (not leftSide) then
		-- we get the length of the grpNoteSplashes group
		local length = getProperty('grpNoteSplashes.length');
		-- we itrate on every splash in grpNoteSplashes
		for i = 0, length do
			-- if we're at the groups length
			if i == length then
				-- then the new splash will
				-- be added to the end of
				-- the group, and its index 
				-- will be the group's length
				table.insert(MissSplashIndex, length);
				break;
			end
			-- if the current splash doesn't exist
			if not getPropertyFromGroup('grpNoteSplashes', i, 'exists') then
				-- then the new splash will
				-- be recycled as this splash,
				-- and its index will be the 
				-- same as this one's.
				table.insert(MissSplashIndex, i);
				break;
			end
		end
		if halo then
			-- we play the death sound
			playSound('death');
			return;
		end
		-- we play the burnSound
		playSound('burnSound');
	end
end

function opponentNoteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' and leftSide then
		-- we get the length of the grpNoteSplashes group
		local length = getProperty('grpNoteSplashes.length');
		-- we itrate on every splash in grpNoteSplashes
		for i = 0, length do
			-- if we're at the groups length
			if i == length then
				-- then the new splash will
				-- be added to the end of
				-- the group, and its index 
				-- will be the group's length
				table.insert(MissSplashIndex, length);
				break;
			end
			-- if the current splash doesn't exist
			if not getPropertyFromGroup('grpNoteSplashes', i, 'exists') then
				-- then the new splash will
				-- be recycled as this splash,
				-- and its index will be the 
				-- same as this one's.
				table.insert(MissSplashIndex, i);
				break;
			end
		end
		if halo then
			-- we play the death sound
			playSound('death');
			return;
		end
		-- we play the burnSound
		playSound('burnSound');
	end
end

function onEvent(name)
	-- toggles halo note
	if name == "Signal-Toggle Halo Note" then
		halo = not halo;
	end
end

function onUpdatePost(elapsed)
	-- if we have a missed fire note on the current frame
	if MissSplashIndex[1] ~= nil then
		-- we itrate on every splash
		for i,v in ipairs(MissSplashIndex) do
			-- we set it's offset to a good-looking value
			setPropertyFromGroup('grpNoteSplashes', v, 'offset.x', -20);
			setPropertyFromGroup('grpNoteSplashes', v, 'offset.y', -20);
		end
		-- we make MissSplashIndex empty again.
		MissSplashIndex = {};
	end
end