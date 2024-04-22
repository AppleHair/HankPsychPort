
----------------------
--    WIP DON'T LOOK
----------------------

ResultScreenActive = false;
UnlockScreenActive = false;
---@type any
UnlockedObjectName = nil;
---@type any
UnlockedTitleName = nil;
UnlockedColor = 0x5D3D6F;
BGReady = false;
ResultsShown = false;

function onCreate()
    addHaxeLibrary("CoolUtil", "backend");
    addHaxeLibrary("CustomFadeTransition", "backend");
    addHaxeLibrary("FlxGradient", "flixel.util");
    addHaxeLibrary("FlxTrail", "flixel.addons.effects");
    addHaxeLibrary("FlxBackdrop", "flixel.addons.display");
end

function onEvent(name, value1, value2)
    if name == "Signal-Add Unlocked Screen" then
        if not luaSpriteExists(value1) then
            close();
        end

        UnlockedObjectName = value1;
        UnlockedTitleName = (luaSpriteExists(value2) and value2 or nil);
        UnlockedColor = runHaxeCode([[
            return FlxColor.fromInt(CoolUtil.dominantColor(game.modchartSprites.get("]]..value1..[[")));
        ]]);
    elseif name == "Signal-Set Unlocked Screen Color" then
        UnlockedColor = FlxColor(value1);
    end
end

function onEndSong()
    local tweenTag = "";
    if not ResultsShown then
        tweenTag = "ResultScreenTransition";
    elseif UnlockedObjectName ~= nil then
        tweenTag = "UnlockScreenTransition";
    end
    if tweenTag ~= "" then
        runHaxeCode([[
            FlxG.state.openSubState(new CustomFadeTransition(0.6, false));
            CustomFadeTransition.finishCallback = function() {
                PlayState.instance.camGame.alpha = 0.0;
                PlayState.instance.camHUD.alpha = 0.0;
                PlayState.instance.camOther.alpha = 0.0;
                FlxG.state.closeSubState();
            };
            CustomFadeTransition.nextCamera = PlayState.instance.camOther;
        ]]);
        runTimer(tweenTag, 0.65);
        return Function_Stop;
    end
    return Function_Continue;
end

AllowExitResults = false;
BGScrollAmount = 0;
function onUpdate(elapsed)
    if not ResultScreenActive then
        return;
    end

    BGScrollAmount = (BGScrollAmount + 60 * elapsed) % getProperty('ResultScreenBG.pixels.width');
    setProperty('ResultScreenBG.offset.x', BGScrollAmount);

    if AllowExitResults and keyPressed("accept") then
        playSound("confirmMenu", 1);
        AllowExitResults = false;
        ResultsShown = true;
        endSong();
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "ResultScreenTransition" then
        SetupResultScreenBG();
        ResultScreenActive = true;
        UnlockScreenActive = false;
        doTweenAlpha('ResultScreenEnter', 'camOther', 1.0, 1, "linear");
    elseif tag == "UnlockScreenTransition" then
        SetupUnlockedScreen();
        UnlockScreenActive = true;
        ResultScreenActive = false;
        setProperty('camOther.alpha', 1.0);

        playSound("woosh", 1);

        doTweenAlpha('BGEnter', 'ResultScreenBG', 1.0, 2, "cubeout");
        doTweenY('RevealUp', 'ResultBlackUp', getProperty('ResultBlackUp.y') - screenHeight/4, 2, "cubeout");
        doTweenY('GRevealUp', 'ResultGradientUp', getProperty('ResultGradientUp.y') - screenHeight/4, 2, "cubeout");
        doTweenY('RevealDown', 'ResultBlackDown', getProperty('ResultBlackDown.y') + screenHeight/4, 2, "cubeout");
        doTweenY('GRevealDown', 'ResultGradientDown', getProperty('ResultGradientDown.y') + screenHeight/4, 2, "cubeout");
        doTweenX('RevealObject', UnlockedObjectName, MiddleX, 2, "cubeout");
        runTimer("WaitText", 1);
    elseif tag == "WaitText" then
        doTweenY('RevealText', 'UnlockedText', 20, 0.5, "quadout");
        runTimer("HideText", 1.5);
    elseif tag == "HideText" then
        doTweenY('HideText', 'UnlockedText', -233, 1, "cubeout");
    elseif tag == "HideBG" then
        doTweenAlpha('BGExit', 'ResultScreenBG', 0.0, 1.5, "cubein");
        doTweenY('HideUp', 'ResultBlackUp', getProperty('ResultBlackUp.y') + screenHeight/4, 1.5, "cubein");
        doTweenY('GHideUp', 'ResultGradientUp', getProperty('ResultGradientUp.y') + screenHeight/4, 1.5, "cubein");
        doTweenY('HideDown', 'ResultBlackDown', getProperty('ResultBlackDown.y') - screenHeight/4, 1.5, "cubein");
        doTweenY('GHideDown', 'ResultGradientDown', getProperty('ResultGradientDown.y') - screenHeight/4, 1.5, "cubein");
        doTweenX('HideObject', UnlockedObjectName, -(getProperty(UnlockedObjectName..'.frameWidth') + screenWidth/2) +
            getProperty(UnlockedObjectName..'.offset.x'), 1.5, "cubein");
        if UnlockedTitleName ~= nil then
            doTweenX('HideTitle', UnlockedTitleName, getProperty(UnlockedTitleName..'.frameWidth') + screenWidth * 1.5 +
                getProperty(UnlockedObjectName..'.offset.x'), 1.25, "cubein");
        end
    end
end

function onTweenCompleted(tag)
    if tag == "ResultScreenEnter" then
        AllowExitResults = true;
    elseif tag == "RevealText" then
        cameraFlash("camOther", "FFFFFF", 0.2, false);
        cameraShake("camOther", 0.002, 0.2);
        playSound("unlocksound", 1);

        if UnlockedTitleName == nil then
            setProperty(UnlockedObjectName..'.color', 0xFFFFFF);
            setProperty('UnlockedTrail.color', 0xFFFFFF);
        else
            setProperty(UnlockedTitleName..'.alpha', 1.0);
        end
        
        runTimer("HideBG", 1.25);
    elseif tag == "BGExit" then
        UnlockedObjectName = nil;
        endSong();
    end
end

function onPause()
    if ResultScreenActive or UnlockScreenActive then
        return Function_Stop;
    end
    return Function_Continue;
end

function SetupResultScreenBG()
    -- -- onlinePlay = true | false
    -- local runningUMM = onlinePlay ~= nil;
    -- if runningUMM then
    if onlinePlay ~= nil then
        makeLuaSprite('ResultScreenBG', "menuDesat", 0, 0);
    else
        runHaxeCode('setVar("ResultScreenBG", new FlxBackdrop(Paths.image("menuDesat")));');
    end
    setObjectCamera('ResultScreenBG', "camOther");
    screenCenter('ResultScreenBG', 'XY');
    setProperty('ResultScreenBG.offset.y', -5);
    setProperty('ResultScreenBG.color', 0x6A4280);
    setProperty('ResultScreenBG.alpha', 1);

    makeLuaSprite('ResultBlackUp', "", 0, 0);
    makeGraphic('ResultBlackUp', screenWidth, screenHeight/2, "000000");
    setObjectCamera('ResultBlackUp', "camOther");
    screenCenter('ResultBlackUp', 'XY');
    setProperty('ResultBlackUp.y', getProperty('ResultBlackUp.y') - screenHeight * 0.55);

    makeLuaSprite('ResultBlackDown', "", 0, 0);
    makeGraphic('ResultBlackDown', screenWidth, screenHeight/2, "000000");
    setObjectCamera('ResultBlackDown', "camOther");
    screenCenter('ResultBlackDown', 'XY');
    setProperty('ResultBlackDown.y', getProperty('ResultBlackDown.y') + screenHeight * 0.55);

    makeLuaSprite('ResultGradientUp', "", 0, 0);
    setObjectCamera('ResultGradientUp', "camOther");
    runHaxeCode([[
        game.modchartSprites.get("ResultGradientUp").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.3, [FlxColor.BLACK, 0xDB000000,
             0xA0000000, 0x60000000, 0x22000000, FlxColor.TRANSPARENT]);
    ]]);
    setProperty('ResultGradientUp.scale.x', screenWidth);
    screenCenter('ResultGradientUp', 'XY');
    setProperty('ResultGradientUp.y', getProperty('ResultGradientUp.y') - screenHeight * 0.15);

    makeLuaSprite('ResultGradientDown', "", 0, 0);
    setObjectCamera('ResultGradientDown', "camOther");
    runHaxeCode([[
        game.modchartSprites.get("ResultGradientDown").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.3, [FlxColor.TRANSPARENT, 0x22000000,
             0x60000000, 0xA0000000, 0xDB000000, FlxColor.BLACK]);
    ]]);
    setProperty('ResultGradientDown.scale.x', screenWidth);
    screenCenter('ResultGradientDown', 'XY');
    setProperty('ResultGradientDown.y', getProperty('ResultGradientDown.y') + screenHeight * 0.15);

    addLuaSprite('ResultScreenBG');
    addLuaSprite('ResultBlackUp');
    addLuaSprite('ResultBlackDown');
    addLuaSprite('ResultGradientUp');
    addLuaSprite('ResultGradientDown');

    BGReady = true;
end

---Creates all the necessary sprites for the unlocked screen
function SetupUnlockedScreen()
    -- If the result screen was active
    if ResultScreenActive then
        -- Remove all result screen sprites
        -- exepct the background ones.
    end
    -- if the background sprites
    -- weren't created, create them
    if not BGReady then
        SetupResultScreenBG();
    end

    -- Setup the background image for the unlocked screen
    setProperty('ResultScreenBG.color', UnlockedColor);
    scaleObject('ResultScreenBG', 1.125, 1.125, false);
    setProperty('ResultScreenBG.offset.y', 12);
    setProperty('ResultScreenBG.offset.x', 37);
    screenCenter('ResultScreenBG', 'XY');
    setProperty('ResultScreenBG.alpha', 0.00001);
    -- Calibrate the scroll amount variable,
    -- so if it starts scrolling again, it'll
    -- start from the beginning (no that there's
    -- a reason for that to happen anyway...)
    BGScrollAmount = 0;

    -- Reset the upper black bar's position.
    -- (It should start on the upper half of the screen)
    screenCenter('ResultBlackUp', 'XY');
    setProperty('ResultBlackUp.y', getProperty('ResultBlackUp.y') - screenHeight/4);

    -- Reset the lower black bar's position.
    -- (It should start on the lower half of the screen)
    screenCenter('ResultBlackDown', 'XY');
    setProperty('ResultBlackDown.y', getProperty('ResultBlackDown.y') + screenHeight/4);

    -- Reset the upper gradient and it's position.
    -- (It should be a smaller and simpler gradient,
    -- and it should start below the upper black bar)
    runHaxeCode([[
        game.modchartSprites.get("ResultGradientUp").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.075, [FlxColor.BLACK, FlxColor.TRANSPARENT]);
    ]]);
    setProperty('ResultGradientUp.scale.x', screenWidth);
    screenCenter('ResultGradientUp', 'XY');
    setProperty('ResultGradientUp.y', getProperty('ResultGradientUp.y') + screenHeight * 0.0375);

    -- Reset the lower gradient and it's position.
    -- (It should be a smaller and simpler gradient,
    -- and it should start above the lower black bar)
    runHaxeCode([[
        game.modchartSprites.get("ResultGradientDown").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.075, [FlxColor.TRANSPARENT, FlxColor.BLACK]);
    ]]);
    setProperty('ResultGradientDown.scale.x', screenWidth);
    screenCenter('ResultGradientDown', 'XY');
    setProperty('ResultGradientDown.y', getProperty('ResultGradientDown.y') - screenHeight * 0.0375);

    -- Using the provided sprite tag, we adjust
    -- the unlocked object's properties to make
    -- it fit in the unlocked screen.
    -- (It should start off-screen and later,
    -- it should move to the center from the
    -- right and then move back off-screen
    -- to the left)
    setObjectCamera(UnlockedObjectName, "camOther");
    screenCenter(UnlockedObjectName, 'XY');
    -- We save the middle x position of the object
    -- to know where to move it back later
    MiddleX = getProperty(UnlockedObjectName..'.x');
    setProperty(UnlockedObjectName..'.x', getProperty(UnlockedObjectName..'.x') + screenWidth/2 +
        getProperty(UnlockedObjectName..'.frameWidth') + getProperty(UnlockedObjectName..'.offset.x'));
    setProperty(UnlockedObjectName..'.alpha', 1.0);
    setProperty(UnlockedObjectName..'.visible', true);
    if UnlockedTitleName == nil then
        -- If a title sprite wasn't provided
        -- along side the object sprite,
        -- It'll start black and will
        -- later become visible.
        setProperty(UnlockedObjectName..'.color', 0x000000);
    else
        -- If a title sprite was provided
        -- along side the object sprite,
        -- we adjust it's properties to make
        -- it fit in the unlocked screen.
        -- (It should start invisible in the
        -- bottom-right corner and later, it
        -- should become visible and move
        -- off-screen to the right)
        setObjectCamera(UnlockedTitleName, "camOther");
        screenCenter(UnlockedTitleName, 'XY');
        setProperty(UnlockedTitleName..'.x', getProperty(UnlockedTitleName..'.x') + screenWidth/4);
        setProperty(UnlockedTitleName..'.y', getProperty(UnlockedTitleName..'.y') + screenHeight/4);
        setProperty(UnlockedTitleName..'.alpha', 0.00001);
        setProperty(UnlockedTitleName..'.visible', true);
    end

    -- Create the text sprite for the unlocked screen.
    -- (Always reads "You have UNLOCKED", starts off-screen
    -- and later, it should move to the upper-left corner
    -- of the screen and then move back off-screen)
    makeLuaSprite('UnlockedText', 'vsresultscreen/unlocked', 50, -233);
    setObjectCamera('UnlockedText', "camOther");

    -- Create a trail efect for
    -- the unlocked object sprite.
    -- (Uses FlxTrail from the
    -- flixel.addons.effects package)
    runHaxeCode([[
        var object:FlxSprite = game.modchartSprites.get("]]..UnlockedObjectName..[[");
        var trail:FlxTrail = new FlxTrail(object, null, 6, ]]..
        math.ceil((getPropertyFromClass('backend.ClientPrefs', 'data.framerate') / 60) * 1.25)
        ..[[, 0.25, 0.05);
        setVar("UnlockedTrail", trail);
    ]]);
    setObjectCamera('UnlockedTrail', "camOther");
    -- If a title sprite wasn't provided
    -- along side the object sprite,
    -- It'll start black and will
    -- later become visible.
    if UnlockedTitleName == nil then
        setProperty('UnlockedTrail.color', 0x000000);
    end

    -- We add all the sprites
    -- we just created to the
    -- screen in the right order
    addLuaSprite('UnlockedTrail');
    addLuaSprite(UnlockedObjectName);
    if UnlockedTitleName ~= nil then
        addLuaSprite(UnlockedTitleName);
    end
    addLuaSprite('UnlockedText');
end