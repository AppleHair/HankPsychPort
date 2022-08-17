function onCreatePost()

	-- I hate this, but it helps
	-- the sprites load without lag lmao
	makeAnimatedLuaSprite('fireNote', 'NOTE_fire', 0, 0);
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

	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fire Note' then
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.3);
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_fire');
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', false);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'Smoke');
			setPropertyFromGroup('unspawnNotes', i, 'ratingDisabled', true);
			setPropertyFromGroup('unspawnNotes', i, 'offsetX', -50);
			setPropertyFromGroup('unspawnNotes', i, 'offsetY', (downscroll and -195.34 or -57.44));-- Set offsetY according to downscroll prefs
			
									-- color calibration--
			-- note
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0 --[[/ 360   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', 0 --[[/ 100   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0 --[[/ 100   if you actually want to change it]]);

			-- splash
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0 --[[/ 360   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', 0 --[[/ 100   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 0 --[[/ 100   if you actually want to change it]]);
		end
	end

	-- precache stuff

	precacheImage('NOTE_fire');
	precacheImage('Smoke');

	precacheSound('burnSound');
end

function onSpawnNote(id, noteData, noteType, isSustainNote)
	if downscroll and noteType == 'Fire Note' then

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

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' then
		-- plays the sound
		playSound('burnSound');
	end
end