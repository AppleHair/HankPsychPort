-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Tricky Appears' then
		--characterPlayAnim('gf', 'Appear', true);
		--setProperty('gf.specialAnim', true);
		--setProperty('dad.curCharater', hank-scared);
		doTweenZoom('TrickyZoomIN','camGame', 0.75, 0.1, 'linear');
		setProperty('camFollowPos.x', 500);
		setProperty('camFollowPos.y', 160);
		--debugPrint('Event triggered: ', name, CLOWN, ENGAGED);
	end
end