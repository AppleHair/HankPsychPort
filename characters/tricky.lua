function onCreatePost()
    -- we add the blood effect script for use with tricky's fall animation
	addLuaScript('custom_events/Blood Effect', true);

    makeLuaSprite('SheFrikingFlyy','GF go bye bye', defaultGirlfriendX, defaultGirlfriendY);
	-- setProperty('SheFrikingFlyy.visible', false);
	setProperty('SheFrikingFlyy.alpha', 0.00001);

    makeAnimatedLuaSprite('Speakers','speakers', defaultGirlfriendX, defaultGirlfriendY + 305);
	addAnimationByPrefix('Speakers', 'Boop', 'speakers', 24, false);
    -- setProperty('Speakers.visible', false);
    setProperty('Speakers.alpha', 0.00001);

    -- I set the alpha to 0.00001 (not 0 and not .visible = false), 
	-- and because of that the game engine thinks it needs to load the
	-- sprites into the stage, although you can't actually see
	-- them. Like that, I can load sprites early and avoid lag.

    addLuaSprite('Speakers',false);
    addLuaSprite('SheFrikingFlyy',true);

    precacheImage('speakers');
    precacheImage('GF go bye bye');
end

function onEvent(name, value1, value2)
    if name == 'Play Animation' then
        if value2 == 'gf' then
            if value1 == 'Enter' then
                -- setProperty('Speakers.visible', true);
                setProperty('Speakers.alpha', 1);
                -- setProperty('SheFrikingFlyy.visible', true);
                setProperty('SheFrikingFlyy.alpha', 1);
                setProperty('SheFrikingFlyy.velocity.x', 15000);
                -- SheFrikingFlyy!!
            end
            if value1 == 'Turn' then
                -- we set blood position
                triggerEvent('Set Blood Effect Pos', defaultGirlfriendX + 15, defaultGirlfriendY - 85);
                -- we make the character stunned to prevent him from playing the idle animation
                setProperty('gf.stunned', true);
                -- we set specialAnim to false to prevent him from playing the idle animation anyway
                setProperty('gf.specialAnim', false);

                -- I see a lot of people who make separate sprites for character animations which
                -- shouldn't be followed by the idle animation. This can cause lag problems if not done
                -- right (without the alpha = 0.00001 thing), uses more RAM then It needs to 
                -- (because of all the FlxSprite object that are created) and makes your code unorganized.
                -- There are also people who make separate characters, which is better performance wise,
                -- but worse RAM wise, because the objects of the Character class are MUCH heavier.
                
                -- The code above reaches the same goal, but without making any extra 
                -- sprites or characters. just one character for all of the animations.
            end
            if value1 == 'Fall' then
                -- we play the blood animation
                triggerEvent('Add Blood Effect', '', '');
                if getPropertyFromClass('states.PlayState', 'curStage') == "Nevada" then
                    return;
                end
                -- and now he falls. bye bye!
                setProperty('gf.velocity.y', -2500);
                setProperty('gf.acceleration.y', 9000);
                setProperty('gf.velocity.x', 2500);
                setProperty('gf.angularVelocity', 0.5);
            end
        end
    end
end

function onBeatHit()
    playAnim('Speakers', 'Boop', true);
end

-- tells us if SheFrikingFlyy is removed
local SheFrikingFlyyRemoved = false;
-- true if tricky is gone
local trickyIsGone = false;
function onUpdate(elapsed)

    -- The Sprite Destroyer
	-----------------------------------------------

	-- we make sure that if SheFrikingFlyy goes off-screen, it gets removed
	if not SheFrikingFlyyRemoved then
		if getProperty('SheFrikingFlyy.x') >= 1700 then
            -- we remove SheFrikingFlyy
			removeLuaSprite('SheFrikingFlyy', true);
			-- we set this value to true in order
            -- to not check this again
			SheFrikingFlyyRemoved = true;
		end
	end

    if getPropertyFromClass('states.PlayState', 'curStage') == "Nevada" then
        return;
    end

    -- we make sure that if tricky goes off-screen, he stops and becomes invisible
    if not trickyIsGone and getProperty('gf.x') >= 1700 then
        -- we stop tricky and make him invisible
		setProperty('gf.velocity.y', 0);
		setProperty('gf.acceleration.y', 0);
        setProperty('gf.velocity.x', 0);
        setProperty('gf.angularVelocity', 0);
        setProperty('gf.angle', 0);
		setProperty('gf.visible', false);
        -- we set this value to true in order
        -- to not check this again
		trickyIsGone = true;
	end
end