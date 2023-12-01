function onEvent(name, value1, value2)
    if name == '0.7.1h clearNotes' then
        -- so there is a bug with runHaxeCode
        -- in psych engine 0.7.1h where you can
        -- run this function only once per script,
        -- so I needed to make a second script
        -- to run this function twice.
        runHaxeCode([[
		game.playerStrums.clear();
		game.opponentStrums.clear();
		game.strumLineNotes.clear();
	    ]]);
    end
end