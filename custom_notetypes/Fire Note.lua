function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Fire Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fire Note' then
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.3);
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_fire'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'Smoke'); --Change note splash texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', false);
			setPropertyFromGroup('unspawnNotes', i, 'offsetX', getPropertyFromGroup('unspawnNotes', i, 'offsetX') - 50);
			setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') - 57.44);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', -15 / 360);-- color calibration
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', -15 / 100);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 15 / 100);
		end
	end
	precacheImage('NOTE_fire');
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' then
		playSound('burnSound');
	end
end