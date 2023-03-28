function onCreate()
        -- Static Lua Sprites --

    makeLuaSprite('HotdogStation','NevadaHotdog', 1010, 441);
    setLuaSpriteScrollFactor('HotdogStation', 1.38, 1.35);
    scaleObject('HotdogStation', 1.25, 1.25, true);

    makeLuaSprite('Rock','The Rock', -776, 704);
    setLuaSpriteScrollFactor('Rock', 1.38, 1.35);
    scaleObject('Rock', 1.32, 1.32, true);

    makeLuaSprite('Ground','NevadaGround', -795, 458);
    scaleObject('Ground', 1.45, 1.45, true);

    makeLuaSprite('RightCliff','NevadaRightCliff', 1173, -246);
    setLuaSpriteScrollFactor('RightCliff', 0.5, 0.5);
    scaleObject('RightCliff', 1.45, 1.45, true);

    makeLuaSprite('LeftCliff','NevadaLeftCliff', -550, -213);
    setLuaSpriteScrollFactor('LeftCliff', 0.5, 0.5);
    scaleObject('LeftCliff', 1.45, 1.45, true);

    makeLuaSprite('Sky','NevadaSky', -345, -425);
    setLuaSpriteScrollFactor('Sky', 0.1, 0.1);
    scaleObject('Sky', 1.16, 1.16, true);

        -- Animated Lua Sprites --

    makeAnimatedLuaSprite('helicopter', 'helicopter', -2500, -270);
    addAnimationByPrefix('helicopter', 'Fly', 'Fly', 24, true);
    setScrollFactor('helicopter', 0.4, 0.3);
    scaleObject('helicopter', 1.15, 1.15, true);

      -- Adding to PlayState --
	
	addLuaSprite('Sky',false);
	addLuaSprite('helicopter',false);
	addLuaSprite('LeftCliff',false);
	addLuaSprite('RightCliff',false);
	addLuaSprite('Ground',false);
	addLuaSprite('HotdogStation',true);
	addLuaSprite('Rock',true);

    		-- Precaches --

	precacheImage('helicopter');
end


----------------------------------------------------------------------------------------------------------------------
		-- Camera Shit --
----------------------------------------------------------------------------------------------------------------------
dadCamPos = {419.5, 398.5};
bfCamPos = {705.5, 398.5};
gfCamPos = {565, 170};

function onMoveCamera(focus)
    if focus == 'gf' then
		-- we override the character's camera positions
		setProperty('camFollow.x', gfCamPos[1]);
		setProperty('camFollow.y', gfCamPos[2]);
	end
	if focus == 'dad' then
		-- we override the character's camera positions
		setProperty('camFollow.x', dadCamPos[1]);
		setProperty('camFollow.y', dadCamPos[2]);
	end
	if focus == 'boyfriend' then
		-- we override the character's camera positions
		setProperty('camFollow.x', bfCamPos[1]);
		setProperty('camFollow.y', bfCamPos[2]);
	end
end

function onStartSong()
    setProperty('helicopter.velocity.x', 430);

    if songName == "Tutorial" then
        dadCamPos = {565, 170};
        -- doesn't work...
    end
end