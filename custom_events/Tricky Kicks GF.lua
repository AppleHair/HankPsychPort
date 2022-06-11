-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Tricky Kicks GF' then
		triggerEvent('Change Character', 'gf', tostring(value1));
		triggerEvent('Play Animation', tostring(value2), 'gf');
		setProperty('She friking flyy.visible', true);
		setProperty('She friking flyy.velocity.x', 15000);
	end
end