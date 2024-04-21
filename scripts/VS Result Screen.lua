
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

function onCreatePost()
    if UnlockedObjectName == nil then
        close();
    end
end

function onEndSong()
    if not ResultsShown then
        runHaxeCode([[
            FlxG.state.openSubState(new CustomFadeTransition(0.6, false));
            CustomFadeTransition.finishCallback = function() {
                PlayState.instance.camGame.alpha = 0.0;
                PlayState.instance.camHUD.alpha = 0.0;
                PlayState.instance.camOther.alpha = 0.0;
                FlxG.state.closeSubState();
            };
        ]]);
        runTimer("ResultScreenTransition", 0.65);
        return Function_Stop;
    end
    if UnlockedObjectName ~= nil then
        runHaxeCode([[
            FlxG.state.openSubState(new CustomFadeTransition(0.6, false));
            CustomFadeTransition.finishCallback = function() {
                PlayState.instance.camGame.alpha = 0.0;
                PlayState.instance.camHUD.alpha = 0.0;
                PlayState.instance.camOther.alpha = 1.0;
                FlxG.state.closeSubState();
            };
        ]]);
        runTimer("UnlockScreenTransition", 0.65);
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
    setProperty('ResultScreenBG.offset.x', 37 + BGScrollAmount * 1.125);

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

        BGScrollAmount = 0;
        setProperty('ResultScreenBG.offset.x', 37);

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
    runHaxeCode('setVar("ResultScreenBG", new FlxBackdrop(Paths.image("menuDesat")));');
    scaleObject('ResultScreenBG', 1.125, 1.125, false);
    setProperty('ResultScreenBG.offset.y', 12);
    setProperty('ResultScreenBG.offset.x', 37);
    screenCenter('ResultScreenBG', 'XY');
    setObjectCamera('ResultScreenBG', "camOther");
    setProperty('ResultScreenBG.color', 0x5D3D6F);

    makeLuaSprite('ResultBlackUp', "", 0, 0);
    makeGraphic('ResultBlackUp', screenWidth, screenHeight/2, "000000");
    setObjectCamera('ResultBlackUp', "camOther");
    screenCenter('ResultBlackUp', 'XY');
    setProperty('ResultBlackUp.y', getProperty('ResultBlackUp.y') - screenHeight/2);

    makeLuaSprite('ResultBlackDown', "", 0, 0);
    makeGraphic('ResultBlackDown', screenWidth, screenHeight/2, "000000");
    setObjectCamera('ResultBlackDown', "camOther");
    screenCenter('ResultBlackDown', 'XY');
    setProperty('ResultBlackDown.y', getProperty('ResultBlackDown.y') + (screenHeight*7)/12);

    makeLuaSprite('ResultGradientUp', "", getProperty('ResultBlackUp.x'),
        getProperty('ResultBlackUp.y') + screenHeight * 0.5);
    runHaxeCode([[
        game.modchartSprites.get("ResultGradientUp").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.1, [FlxColor.BLACK, 0x0]);
    ]]);
    setProperty('ResultGradientUp.scale.x', screenWidth);
    updateHitbox('ResultGradientUp');
    setObjectCamera('ResultGradientUp', "camOther");

    makeLuaSprite('ResultGradientDown', "", getProperty('ResultBlackDown.x'),
        getProperty('ResultBlackDown.y') - screenHeight * 0.1);
    runHaxeCode([[
        game.modchartSprites.get("ResultGradientDown").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.1, [0x0, FlxColor.BLACK]);
    ]]);
    setProperty('ResultGradientDown.scale.x', screenWidth);
    updateHitbox('ResultGradientDown');
    setObjectCamera('ResultGradientDown', "camOther");

    addLuaSprite('ResultScreenBG');
    addLuaSprite('ResultBlackUp');
    addLuaSprite('ResultBlackDown');
    addLuaSprite('ResultGradientUp');
    addLuaSprite('ResultGradientDown');

    BGReady = true;
end

function SetupUnlockedScreen()
    if not BGReady then
        SetupResultScreenBG();
    end

    setProperty('ResultScreenBG.color', UnlockedColor);
    setProperty('ResultScreenBG.alpha', 0.00001);

    screenCenter('ResultBlackUp', 'XY');
    setProperty('ResultBlackUp.y', getProperty('ResultBlackUp.y') - screenHeight/4);

    screenCenter('ResultBlackDown', 'XY');
    setProperty('ResultBlackDown.y', getProperty('ResultBlackDown.y') + screenHeight/3);

    setProperty('ResultGradientUp.y', getProperty('ResultBlackUp.y') + screenHeight * 0.5);

    setProperty('ResultGradientDown.y', getProperty('ResultBlackDown.y') - screenHeight * 0.1);

    screenCenter(UnlockedObjectName, 'XY');
    MiddleX = getProperty(UnlockedObjectName..'.x');
    setProperty(UnlockedObjectName..'.x', getProperty(UnlockedObjectName..'.x') + screenWidth/2 +
        getProperty(UnlockedObjectName..'.frameWidth') + getProperty(UnlockedObjectName..'.offset.x'));
    setObjectCamera(UnlockedObjectName, "camOther");
    if UnlockedTitleName == nil then
        setProperty(UnlockedObjectName..'.color', 0x000000);
    else
        setObjectCamera(UnlockedTitleName, "camOther");
        screenCenter(UnlockedTitleName, 'XY');
        setProperty(UnlockedTitleName..'.x', getProperty(UnlockedTitleName..'.x') + screenWidth/4);
        setProperty(UnlockedTitleName..'.y', getProperty(UnlockedTitleName..'.y') + screenHeight/4);
        setProperty(UnlockedTitleName..'.alpha', 0.00001);
        setProperty(UnlockedTitleName..'.visible', true);
    end

    makeLuaSprite('UnlockedText', 'unlocked', 50, -233);
    setObjectCamera('UnlockedText', "camOther");

    runHaxeCode([[
        var object:FlxSprite = game.modchartSprites.get("]]..UnlockedObjectName..[[");
        var trail:FlxTrail = new FlxTrail(object, null, 6, ]]..
        math.ceil((getPropertyFromClass('backend.ClientPrefs', 'data.framerate') / 60) * 1.25)
        ..[[, 0.25, 0.05);
        setVar("UnlockedTrail", trail);
    ]]);
    setObjectCamera('UnlockedTrail', "camOther");
    if UnlockedTitleName == nil then
        setProperty('UnlockedTrail.color', 0x000000);
    end

    addLuaSprite('UnlockedTrail');
    addLuaSprite(UnlockedObjectName);
    if UnlockedTitleName ~= nil then
        addLuaSprite(UnlockedTitleName);
    end
    addLuaSprite('UnlockedText');
end