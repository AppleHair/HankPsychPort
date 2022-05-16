function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Fire Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fire Note' then
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.3);
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_fire'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true);
			setPropertyFromGroup('unspawnNotes', i, 'ratingDisabled', true);
			setPropertyFromGroup('unspawnNotes', i, 'offsetX', getPropertyFromGroup('unspawnNotes', i, 'offsetX') - 50);
			setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') - 57.44);
			
			
									-- color calibration
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0 --[[/ 360   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', 0 --[[/ 100   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0 --[[/ 100   if you actually want to change it]]);
		end
	end
	precacheImage('NOTE_fire');
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' then
		playSound('burnSound');
	end
end