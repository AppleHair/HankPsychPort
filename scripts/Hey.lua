-- This is a very simple script that needs no explanation.

function onUpdate(elapsed)
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
        triggerEvent('Play Animation', 'hey', 'bf');
    end
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then
        triggerEvent('Play Animation', 'hey', 'dad');
    end
end