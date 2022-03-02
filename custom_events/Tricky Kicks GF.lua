-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Tricky Kicks GF' then
		triggerEvent('Play Animation', 'Enter', 'gf');
		setProperty('She friking flyy.visible', true);
		setProperty('She friking flyy.velocity.x', 30000);
		--debugPrint('Event triggered: ', name, CLOWN, ENGAGED);
	end
end