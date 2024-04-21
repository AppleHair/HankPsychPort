
----------------------
--    WIP DON'T LOOK
----------------------

UnlockedScreenActive = false;
---@type any
UnlockedObjectName = nil;
---@type any
UnlockedTitleName = nil;
UnlockedColor = 0xFFFFFF;

function onEvent(name, value1, value2)
    if name == "Signal-Enable Unlocked Screen" then
        if not luaSpriteExists(value1) then
            close();
        end
        UnlockedObjectName = value1;
        UnlockedTitleName = (luaSpriteExists(value2) and value2 or nil);
        addHaxeLibrary("CoolUtil", "backend");
        UnlockedColor = runHaxeCode([[
            return FlxColor.fromInt(CoolUtil.dominantColor(game.modchartSprites.get("]]..value1..[[")));
        ]]);
    elseif name == "Signal-Set Unlock Screen Color" then
        UnlockedColor = FlxColor(value1);
    end
end

function onCreatePost()
    if UnlockedObjectName == nil then
        close();
    end
end

function onEndSong()
    if UnlockedObjectName ~= nil then
        addHaxeLibrary("CustomFadeTransition", "backend");
        addHaxeLibrary("FlxGradient", "flixel.util");
        addHaxeLibrary("FlxTrail", "flixel.addons.effects");
        addHaxeLibrary("ModchartSprite", "psychlua");
        runHaxeCode([[
            FlxG.state.openSubState(new CustomFadeTransition(0.6, false));
            CustomFadeTransition.finishCallback = function() {
                PlayState.instance.camGame.alpha = 0.0;
                PlayState.instance.camHUD.alpha = 0.0;
                PlayState.instance.camOther.alpha = 1.0;
                FlxG.state.closeSubState();
            };
        ]]);
        runTimer("TransitionEnd", 0.6);
        return Function_Stop;
    end
    return Function_Continue;
end

function initUnlockedScreen()
    makeLuaSprite('UnlockedScreenBG', 'menuDesat', 0, 0);
    setGraphicSize('UnlockedScreenBG', screenWidth, screenHeight);
    scaleObject('UnlockedScreenBG', 1.125, 1.125, false);
    setProperty('UnlockedScreenBG.offset.y', 12);
    setProperty('UnlockedScreenBG.offset.x', 37);
    screenCenter('UnlockedScreenBG', 'XY');
    setProperty('UnlockedScreenBG.color', UnlockedColor);
    setProperty('UnlockedScreenBG.alpha', 0.00001);
    setObjectCamera('UnlockedScreenBG', "camOther");
    addLuaSprite('UnlockedScreenBG');



    makeLuaSprite('UnlockedBlackUp', "", 0, 0);
    makeGraphic('UnlockedBlackUp', screenWidth, screenHeight/2, "000000");
    setObjectCamera('UnlockedBlackUp', "camOther");
    screenCenter('UnlockedBlackUp', 'XY');
    setProperty('UnlockedBlackUp.y', getProperty('UnlockedBlackUp.y') - screenHeight/4);



    makeLuaSprite('UnlockedBlackDown', "", 0, 0);
    makeGraphic('UnlockedBlackDown', screenWidth, screenHeight/2, "000000");
    setObjectCamera('UnlockedBlackDown', "camOther");
    screenCenter('UnlockedBlackDown', 'XY');
    setProperty('UnlockedBlackDown.y', getProperty('UnlockedBlackDown.y') + screenHeight/3);



    makeLuaSprite('UnlockedGradientUp', "", getProperty('UnlockedBlackUp.x'),
        getProperty('UnlockedBlackUp.y') + screenHeight * 0.5);
    runHaxeCode([[
        game.modchartSprites.get("UnlockedGradientUp").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.1, [FlxColor.BLACK, 0x0]);
    ]]);
    setProperty('UnlockedGradientUp.scale.x', screenWidth);
    updateHitbox('UnlockedGradientUp');
    setObjectCamera('UnlockedGradientUp', "camOther");



    makeLuaSprite('UnlockedGradientDown', "", getProperty('UnlockedBlackDown.x'),
        getProperty('UnlockedBlackDown.y') - screenHeight * 0.1);
    runHaxeCode([[
        game.modchartSprites.get("UnlockedGradientDown").pixels = 
            FlxGradient.createGradientBitmapData(1, FlxG.height * 0.1, [0x0, FlxColor.BLACK]);
    ]]);
    setProperty('UnlockedGradientDown.scale.x', screenWidth);
    updateHitbox('UnlockedGradientDown');
    setObjectCamera('UnlockedGradientDown', "camOther");


    screenCenter(UnlockedObjectName, 'XY');
    local middle = getProperty(UnlockedObjectName..'.x');
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



    addLuaSprite('UnlockedBlackUp');
    addLuaSprite('UnlockedBlackDown');
    addLuaSprite('UnlockedGradientUp');
    addLuaSprite('UnlockedGradientDown');
    addLuaSprite(UnlockedObjectName);
    if UnlockedTitleName ~= nil then
        addLuaSprite(UnlockedTitleName);
    end
    addLuaSprite('UnlockedText');



    runHaxeCode([[
        var object:ModchartSprite = game.modchartSprites.get("]]..UnlockedObjectName..[[");
        var trail:FlxTrail = new FlxTrail(object, null, 6, 5, 0.25, 0.05);
        trail.cameras = [game.camOther];
        game.insert(game.members.indexOf(object), trail);
        setVar("UnlockedTrail", trail);
    ]]);
    if UnlockedTitleName == nil then
        setProperty('UnlockedTrail.color', 0x000000);
    end


    
    playSound("woosh", 1);

    doTweenAlpha('BGEnter', 'UnlockedScreenBG', 1.0, 2, "cubeout");
    doTweenY('RevealUp', 'UnlockedBlackUp', getProperty('UnlockedBlackUp.y') - screenHeight/4, 2, "cubeout");
    doTweenY('GRevealUp', 'UnlockedGradientUp', getProperty('UnlockedGradientUp.y') - screenHeight/4, 2, "cubeout");
    doTweenY('RevealDown', 'UnlockedBlackDown', getProperty('UnlockedBlackDown.y') + screenHeight/4, 2, "cubeout");
    doTweenY('GRevealDown', 'UnlockedGradientDown', getProperty('UnlockedGradientDown.y') + screenHeight/4, 2, "cubeout");
    doTweenX('RevealObject', UnlockedObjectName, middle, 2, "cubeout");
    runTimer("WaitText", 1);
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "TransitionEnd" then
        UnlockedScreenActive = true;
        initUnlockedScreen();
    end
    if tag == "WaitText" then
        doTweenY('RevealText', 'UnlockedText', 20, 0.5, "quadout");
        runTimer("HideText", 1.5);
    end
    if tag == "HideText" then
        doTweenY('HideText', 'UnlockedText', -233, 1, "cubeout");
    end
    if tag == "HideBG" then
        doTweenAlpha('BGExit', 'UnlockedScreenBG', 0.0, 1.5, "cubein");
        doTweenY('HideUp', 'UnlockedBlackUp', getProperty('UnlockedBlackUp.y') + screenHeight/4, 1.5, "cubein");
        doTweenY('GHideUp', 'UnlockedGradientUp', getProperty('UnlockedGradientUp.y') + screenHeight/4, 1.5, "cubein");
        doTweenY('HideDown', 'UnlockedBlackDown', getProperty('UnlockedBlackDown.y') - screenHeight/4, 1.5, "cubein");
        doTweenY('GHideDown', 'UnlockedGradientDown', getProperty('UnlockedGradientDown.y') - screenHeight/4, 1.5, "cubein");
        doTweenX('HideObject', UnlockedObjectName, -(getProperty(UnlockedObjectName..'.frameWidth') + screenWidth/2) +
            getProperty(UnlockedObjectName..'.offset.x'), 1.5, "cubein");
        if UnlockedTitleName ~= nil then
            doTweenX('HideTitle', UnlockedTitleName, getProperty(UnlockedTitleName..'.frameWidth') + screenWidth * 1.5 +
                getProperty(UnlockedObjectName..'.offset.x'), 1.25, "cubein");
        end
    end
end

function onTweenCompleted(tag)
    if tag == "RevealText" then
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
    end
    if tag == "BGExit" then
        UnlockedScreenActive = false;
        UnlockedObjectName = nil;
        endSong();
    end
end

function onPause()
    if UnlockedScreenActive then
        return Function_Stop;
    end
    return Function_Continue;
end