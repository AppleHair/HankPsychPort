function onCreate()
        -- Static Lua Sprites --

    makeLuaSprite('HotdogStation','NevadaHotdog', 1010, 441);
    setScrollFactor('HotdogStation', 1.38, 1.35);
    scaleObject('HotdogStation', 1.25, 1.25, true);

    makeLuaSprite('Rock','The Rock', -776, 704);
    setScrollFactor('Rock', 1.38, 1.35);
    scaleObject('Rock', 1.32, 1.32, true);

    makeLuaSprite('Ground','NevadaGround', -795, 458);
    scaleObject('Ground', 1.45, 1.45, true);

    makeLuaSprite('RightCliff','NevadaRightCliff', 1173, -246);
    setScrollFactor('RightCliff', 0.5, 0.5);
    scaleObject('RightCliff', 1.45, 1.45, true);

    makeLuaSprite('LeftCliff','NevadaLeftCliff', -550, -213);
    setScrollFactor('LeftCliff', 0.5, 0.5);
    scaleObject('LeftCliff', 1.45, 1.45, true);

    makeLuaSprite('Sky','NevadaSky', -345, -425);
    setScrollFactor('Sky', 0.1, 0.1);
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
DadCamPos = {419.5, 398.5};
BfCamPos = {705.5, 398.5};
GfCamPos = {565, 170};

function onMoveCamera(focus)
    if focus == 'gf' then
		-- we override the character's camera positions
		setProperty('camFollow.x', GfCamPos[1]);
		setProperty('camFollow.y', GfCamPos[2]);
	end
	if focus == 'dad' then
		-- we override the character's camera positions
		setProperty('camFollow.x', DadCamPos[1]);
		setProperty('camFollow.y', DadCamPos[2]);
	end
	if focus == 'boyfriend' then
		-- we override the character's camera positions
		setProperty('camFollow.x', BfCamPos[1]);
		setProperty('camFollow.y', BfCamPos[2]);
	end
end

function onSongStart()
    setProperty('helicopter.velocity.x', 430);

	-- for tutorial
    if songPath:find("tutorial") ~= nil then
        DadCamPos = GfCamPos;
    end
end

-- tells us if the helicopter is removed
local helicopterRemoved = false;
function onUpdate(elapsed)
    
    -- The Helicopter Destroyer
	-----------------------------------------------

	-- we make sure that if the helicopter goes off-screen, it gets removed
	if not helicopterRemoved then
		if getProperty('helicopter.x') >= 1700 then
			-- we remove the helicopter
			removeLuaSprite('helicopter', true);
			-- we set this value to true in order
            -- to not check this again
			helicopterRemoved = true;
		end
	end
end