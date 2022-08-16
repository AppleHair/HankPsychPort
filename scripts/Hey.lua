function onUpdate(elapsed)
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
        triggerEvent('Play Animation', 'hey', 'bf');
    end
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.H') then
        triggerEvent('Play Animation', 'hey', 'dad');
    end
end