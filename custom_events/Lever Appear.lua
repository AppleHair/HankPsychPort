
-- Used to determine if the game
-- is in multiplayer mode on UMM,
-- and tell the script to close
-- itself accordingly.
local balance = false;

function onCreate()
    -- check if the game is
    -- in multiplayer mode.
    balance = localPlay or onlinePlay;
    -- if we need balance, the 
    -- script will be closed.
    if balance then
        close();
        return;
    end
    -- if we don't need balance,
    -- we'll create the lever.
    makeAnimatedLuaSprite('lever', 'Lever', 395, 405);
    addAnimationByPrefix('lever', 'appear', 'Appear', 24, false);
    addAnimationByPrefix('lever', 'pull', 'Pull', 24, false);
    addAnimationByIndicesLoop('lever', 'pull-loop', 'Pull', "11,12,13,14,15", 24);
    scaleObject('lever', 0.75, 0.75, false);
    setProperty('lever.alpha', 0.00001);
    setObjectCamera('lever', "camHUD");
    addOffset('lever', 'appear', 0, -14);
    addOffset('lever', 'pull', 0, 0);
    addOffset('lever', 'pull-loop', 0, 0);
    addLuaSprite('lever', false);
end

-- tells if the health bar
-- should be drained or not.
local drain = false;

function onUpdatePost(elapsed)
    -- the health bar should be drained
    -- when the lever is pulled.
    if getProperty('lever.animation.curAnim.finished') then
        if getProperty('lever.animation.curAnim.name') == 'appear' then
            playAnim('lever', 'pull');
        elseif getProperty('lever.animation.curAnim.name') == 'pull' then
            playAnim('lever', 'pull-loop');
            drain = true;
        end
    end

    if drain then
        setProperty('health', getProperty('health') - elapsed * 0.1);
    end
end

function onEvent(event)
    if event == "Lever Appear" then
        playAnim('lever', 'appear', true);
        -- setProperty('lever.visible', true);
        setProperty('lever.alpha', 1);
    end
end