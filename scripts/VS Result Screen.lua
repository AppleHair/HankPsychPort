
----------------------
--    WIP DON'T LOOK
----------------------

UnlockedScreenActive = false;
UnlockedObjectPath = "";
UnlockedTitlePath = "";
UnlockedColor = "#FFFFFF";
HasTitle = false;

OffsetX = 0;
OffsetY = 0;
Prefix = "";

function onEvent(name, value1, value2)
    if name == "Signal-Enable Unlocked Screen" then
        if not checkFileExists('images/'..value1..'.png', false) then
            close();
        end
        UnlockedObjectPath = value1;
        UnlockedTitlePath = value2;
        HasTitle = checkFileExists('images/'..value2..'.png', false);
    elseif name == "Signal-Set Unlock Screen Color" then
        UnlockedColor = value1;
    elseif name == "Signal-Set Unlock Object Offset" then
        OffsetX = tonumber(value1);
        OffsetY = tonumber(value2);
    elseif name == "Signal-Set Unlock Animation Prefix" then
        Prefix = value1;
    end
end

function onCreatePost()
    if UnlockedObjectPath == "" then
        close();
    end
end

function onEndSong()
    if UnlockedObjectPath ~= "" then
        addHaxeLibrary("CustomFadeTransition", "backend");
        addHaxeLibrary("FlxGradient", "flixel.util");
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
    screenCenter('UnlockedScreenBG', 'XY');
    setProperty('UnlockedScreenBG.color', FlxColor(UnlockedColor));
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



    if checkFileExists('images/'..UnlockedObjectPath..'.xml', false) then
        makeAnimatedLuaSprite('UnlockedObject', UnlockedObjectPath, 0, 0);
        addAnimationByPrefix('UnlockedObject', 'loop', Prefix, 24, true);
    else
        makeLuaSprite('UnlockedObject', UnlockedObjectPath, 0, 0);
    end
    if not HasTitle then
        setProperty('UnlockedObject.color', 0x000000);
    end
    screenCenter('UnlockedObject', 'XY');
    local middle = getProperty('UnlockedObject.x');
    setProperty('UnlockedObject.x', getProperty('UnlockedObject.x') + screenWidth/2 + getProperty('UnlockedObject.frameWidth') );
    setProperty('UnlockedObject.y', getProperty('UnlockedObject.y') + OffsetY );
    setObjectCamera('UnlockedObject', "camOther");



    makeLuaSprite('UnlockedText', 'unlocked', 50, -233);
    setObjectCamera('UnlockedText', "camOther");



    addLuaSprite('UnlockedBlackUp');
    addLuaSprite('UnlockedBlackDown');
    addLuaSprite('UnlockedGradientUp');
    addLuaSprite('UnlockedGradientDown');
    addLuaSprite('UnlockedObject');
    addLuaSprite('UnlockedText');

    playSound("woosh", 1);

    doTweenAlpha('BGEnter', 'UnlockedScreenBG', 1.0, 2, "cubeout");
    doTweenY('RevealUp', 'UnlockedBlackUp', getProperty('UnlockedBlackUp.y') - screenHeight/4, 2, "cubeout");
    doTweenY('GRevealUp', 'UnlockedGradientUp', getProperty('UnlockedGradientUp.y') - screenHeight/4, 2, "cubeout");
    doTweenY('RevealDown', 'UnlockedBlackDown', getProperty('UnlockedBlackDown.y') + screenHeight/4, 2, "cubeout");
    doTweenY('GRevealDown', 'UnlockedGradientDown', getProperty('UnlockedGradientDown.y') + screenHeight/4, 2, "cubeout");
    doTweenX('RevealObject', 'UnlockedObject', middle + OffsetX, 2, "cubeout");
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
        doTweenAlpha('BGExit', 'UnlockedScreenBG', 0.0, 1.25, "cubein");
        doTweenY('HideUp', 'UnlockedBlackUp', getProperty('UnlockedBlackUp.y') + screenHeight/4, 1.25, "cubein");
        doTweenY('GHideUp', 'UnlockedGradientUp', getProperty('UnlockedGradientUp.y') + screenHeight/4, 1.25, "cubein");
        doTweenY('HideDown', 'UnlockedBlackDown', getProperty('UnlockedBlackDown.y') - screenHeight/4, 1.25, "cubein");
        doTweenY('GHideDown', 'UnlockedGradientDown', getProperty('UnlockedGradientDown.y') - screenHeight/4, 1.25, "cubein");
        doTweenX('HideObject', 'UnlockedObject', -getProperty('UnlockedObject.frameWidth'), 1.25, "cubein");
    end
end

function onTweenCompleted(tag)
    if tag == "RevealText" then
        cameraFlash("camOther", "FFFFFF", 0.2, false);
        cameraShake("camOther", 0.002, 0.2);
        playSound("unlocksound", 1);
        if not HasTitle then
            setProperty('UnlockedObject.color', 0xFFFFFF);
        end
        runTimer("HideBG", 1.25);
    end
    if tag == "BGExit" then
        UnlockedScreenActive = false;
        UnlockedObjectPath = "";
        endSong();
    end
end

function onPause()
    if UnlockedScreenActive then
        return Function_Stop;
    end
    return Function_Continue;
end