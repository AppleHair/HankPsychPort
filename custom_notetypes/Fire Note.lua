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

	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Fire Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fire Note' then
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.3);
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_fire'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', false); --Enable splash
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'Smoke'); --Change splash texture
			setPropertyFromGroup('unspawnNotes', i, 'ratingDisabled', true);
			setPropertyFromGroup('unspawnNotes', i, 'offsetX', getPropertyFromGroup('unspawnNotes', i, 'offsetX') - 50);
			setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') - 57.44);
			
			
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
	precacheImage('NOTE_fire');
	precacheImage('Smoke');

	precacheSound('burnSound');
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' then
		playSound('burnSound');
	end
end