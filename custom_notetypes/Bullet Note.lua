function onCreate()

	-- I present to you... blood
	makeAnimatedLuaSprite('bloodEffect','blood', 550, 0);
	setProperty('bloodEffect.flipX', true);
	addAnimationByPrefix('bloodEffect', 'splat', 'blood 1', 24, false);
	setProperty('bloodEffect.visible', false);
	addLuaSprite('bloodEffect',true);
	
	-- The shot ray creation
	makeLuaSprite('shotRay','shotRay', 220, 360);
	setProperty('shotRay.alpha', 0.7);
	setProperty('shotRay.visible', false);
	addLuaSprite('shotRay',true);
	
	-- Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		-- Check if the note is an Bullet Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'BulletNotes'); -- Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.8);
			
			
									-- color calibration
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0 --[[/ 360   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', 0 --[[/ 100   if you actually want to change it]]);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0 --[[/ 100   if you actually want to change it]]);
		end
	end
	--debugPrint('Script started!')
end



function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Bullet Note' then
		-- BF anim
		cameraShake('game', 0.0075, 0.07);
		triggerEvent('Play Animation', 'dodge', 'bf');

		-- Hank anim
		if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
			triggerEvent('Play Animation', 'shootLEFT', 'dad');
		elseif getProperty('dad.animation.curAnim.name') == 'singDOWN' then
			triggerEvent('Play Animation', 'shootDOWN', 'dad');
		elseif getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
			triggerEvent('Play Animation', 'shootRIGHT', 'dad');
		else
			triggerEvent('Play Animation', 'shootUP', 'dad');
		end
		
		-- shot ray apperence
		setProperty('shotRay.visible', true);
		runTimer('RayFade', 0.07);
		
	end
end

local healthDrain = 0; --- helps in the health Drain prosses
function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Bullet Note' then
		-- BF anim + sound and blood
		cameraShake('game', 0.0075, 0.07);
		triggerEvent('Play Animation', 'hurt', 'bf');
		setProperty('bloodEffect.visible', true);
		luaSpritePlayAnimation('bloodEffect', 'splat', true);
		runTimer('bloodSplat', 0.5);
		playSound('splat');
		
		-- Hank anim
		if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
			triggerEvent('Play Animation', 'shootLEFT', 'dad');
		elseif getProperty('dad.animation.curAnim.name') == 'singDOWN' then
			triggerEvent('Play Animation', 'shootDOWN', 'dad');
		elseif getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
			triggerEvent('Play Animation', 'shootRIGHT', 'dad');
		else
			triggerEvent('Play Animation', 'shootUP', 'dad');
		end
		
		-- shot ray apperence
		setProperty('shotRay.visible', true);
		runTimer('RayFade', 0.07);
		
		-- health Drain trigger
		healthDrain = healthDrain + 1;
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'RayFade' then
		setProperty('shotRay.visible', false);
	end
	if tag == 'bloodSplat' then
		setProperty('bloodEffect.visible', false);
	end
end

function onUpdate(elapsed)	
	-- the health Drain itself
	if healthDrain > 0 then
		healthDrain = healthDrain - 0.3 * elapsed;
		setProperty('health', getProperty('health') - 0.3 * elapsed);
		if healthDrain < 0 then
			healthDrain = 0;
		end
	end
end