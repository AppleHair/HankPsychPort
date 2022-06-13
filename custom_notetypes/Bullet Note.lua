function onCreate()
	-- Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		-- Check if the note is an Bullet Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' then
			-- no sustain bullet notes allowed!
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
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
	end
end

-- helps in the health Drain prosses
local healthDrain = 0;

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Bullet Note' then
		-- health Drain trigger
		healthDrain = healthDrain + 1;
	end
end

function onUpdate(elapsed)
	-- the health Drain itself
	if healthDrain > 0 then
		healthDrain = healthDrain - elapsed * 0.3;
		setProperty('health', getProperty('health') - elapsed * 0.3);
		if healthDrain < 0 then
			healthDrain = 0;
		end
	end
end

-----------------------------------------------------------------------
--  Health Drain code was made by Shadow Mario for Hank Reanimated
--  https://gamebanana.com/mods/328455
-----------------------------------------------------------------------