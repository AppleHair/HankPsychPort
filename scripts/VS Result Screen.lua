
-- short for linear interpolation
local function lerp(a, b, ratio)
    return a + (b - a) * ratio;
end

--[[
	takes RGB color values
	and turns them into
	HEX #RRGGBB format.

	r - red value

	g - green value

	b - blue value
--]]
local function RGBtoHEX(r, g, b)
	-- string.format explanation: https://www.lua.org/pil/20.html#:~:text=The%20function-,string.format,-is%20a%20powerful
	return string.format("#%02x%02x%02x", r, g, b);
end

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

ResultScreenDebug = true;

BGReady = false;
ResultsShown = false;

function onCreate()
    addHaxeLibrary("CoolUtil", "backend");
    addHaxeLibrary("CustomFadeTransition", "backend");
    addHaxeLibrary("FlxGradient", "flixel.util");
    addHaxeLibrary("FlxTrail", "flixel.addons.effects");
    addHaxeLibrary("FlxBackdrop", "flixel.addons.display");
    addHaxeLibrary("FlxRect", "flixel.math");
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
        setProperty('canPause', false);
        setProperty('canReset', false);
        setProperty('endingSong', true);
        setProperty('persistentUpdate', true);
        return Function_Stop;
    end
    return Function_Continue;
end

function getStateFromKeyboard()
    local key = runHaxeCode('return FlxG.keys.firstJustPressed();') - 49;
    return ((key > -1 and key < 8) and key or ResultStateKey);
end

AllowExitResults = false;
BGScrollAmount = 0;

ResultStateKey = 0;
ResultScreenStates = {
    [0] = {0, "shit", 0x6A4280},-- F
    [1] = {16, "shit", 0x6A4280},-- E
    [2] = {32, "bad", 0x6A4280},-- D
    [3] = {47, "bad", 0x4648AA},-- C
    [4] = {63, "good", 0x4648AA},-- B
    [5] = {78, "good", 0xD562E1},-- A
    [6] = {94, "sick", 0x7EF2BE},-- S
    [7] = {100, "sick", 0x12FBE2},-- Ss
};
ResultEnterColors = {{r=51,g=255,b=255}, {r=51,g=51,b=204}};
ResultEnterAlphas = {1, 0.64};

function onUpdate(elapsed)
    if not ResultScreenActive then
        return;
    end

    BGScrollAmount = (BGScrollAmount + 60 * elapsed) % getProperty('ResultScreenBG.pixels.width');
    setProperty('ResultScreenBG.offset.x', BGScrollAmount);

    if ResultScreenDebug then
        if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
            setProperty('Screenshots.visible', not getProperty('Screenshots.visible'));
        end
        local prv = ResultStateKey;
        ResultStateKey = getStateFromKeyboard();
        if prv ~= ResultStateKey then
            debugPrint(tostring(ResultStateKey));
        end
        setProperty('Screenshots.animation.frameIndex', ResultStateKey);
    end

    setProperty('ResultMainRank.animation.frameIndex', math.min(6, ResultStateKey));
    setProperty('ResultScreenBG.color', ResultScreenStates[ResultStateKey][3]);

    if not ResultsShown then
        -- f(x) = (1 - cos((x ∙ π) : 1.5)) : 2
        --  		       ↓
        -- 	     local enterLerp = f(x)
        local enterLerp = (1 - math.cos(os.clock() * math.pi/1.5)) / 2;
        
        setProperty('ResultEnter.color', FlxColor(RGBtoHEX(
            lerp(ResultEnterColors[1].r, ResultEnterColors[2].r, enterLerp),
            lerp(ResultEnterColors[1].g, ResultEnterColors[2].g, enterLerp),
            lerp(ResultEnterColors[1].b, ResultEnterColors[2].b, enterLerp)
        )));
        setProperty('ResultEnter.alpha', lerp(ResultEnterAlphas[1], ResultEnterAlphas[2], enterLerp));
    end

    if AllowExitResults and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then
        setProperty('ResultEnter.color', 0xFFFFFF);
        setProperty('ResultEnter.alpha', 1.0);
        playAnim('ResultEnter', 'pressed');
        playSound("confirmMenu", 1);
        AllowExitResults = false;
        ResultsShown = true;
        endSong();
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "ResultScreenTransition" then
        SetupResultScreenBG();
        SetupResultScreen();
        ResultScreenActive = true;
        UnlockScreenActive = false;
        setProperty('camOther.alpha', 1.0);
        
        makeLuaSprite('ResultFadeTransition', "", 0, 0);
        makeGraphic('ResultFadeTransition', screenWidth, screenHeight, "000000");
        setObjectCamera('ResultFadeTransition', "camOther");
        screenCenter('ResultFadeTransition', 'XY');
        addLuaSprite('ResultFadeTransition');
        doTweenAlpha('ResultScreenEnter', 'ResultFadeTransition', 0.0, 1, "linear");
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
        removeLuaSprite('ResultFadeTransition');
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

function SetupResultScreen()
    makeAnimatedLuaSprite('ResultMainRank', 'vsresultscreen/ranks', 0, 0);
    addAnimationByPrefix('ResultMainRank', 'ranks', 'ranks', 0, false);
    playAnim('ResultMainRank', 'ranks');
    setObjectCamera('ResultMainRank', "camOther");
    screenCenter('ResultMainRank', 'XY');
    setProperty('ResultMainRank.y', getProperty('ResultMainRank.y') + 21);
    setProperty('ResultMainRank.x', getProperty('ResultMainRank.x') + 275);

    makeAnimatedLuaSprite('ResultEnter', 'titleEnter', 0, 0);
    addAnimationByPrefix('ResultEnter', 'idle', 'ENTER IDLE', 0, false);
    addAnimationByPrefix('ResultEnter', 'pressed', 'ENTER PRESSED', 12, true);
    playAnim('ResultEnter', 'idle');
    runHaxeCode('game.modchartSprites.get("ResultEnter").clipRect = new FlxRect(0,0,592,271);');
    setObjectCamera('ResultEnter', "camOther");
    scaleObject('ResultEnter', 0.84, 0.84, false);
    screenCenter('ResultEnter', 'XY');
    setProperty('ResultEnter.y', getProperty('ResultEnter.y') + screenHeight/2 - 59);
    setProperty('ResultEnter.x', getProperty('ResultEnter.x') - screenWidth/2 + 655);
    setProperty('ResultEnter.color', 0x33FFFF);
    
    addLuaSprite('ResultMainRank');
    addLuaSprite('ResultEnter');

    if not ResultScreenDebug then
        return;
    end

    makeAnimatedLuaSprite('Screenshots', 'vsresultscreen/screenshots', 0, 0);
    addAnimationByPrefix('Screenshots', 'screenshots', 'screens', 0, false);
    playAnim('Screenshots', 'screenshots');
    setObjectCamera('Screenshots', "camOther");
    screenCenter('Screenshots', 'XY');
    setProperty('Screenshots.alpha', 0.3);

    addLuaSprite('Screenshots');
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
        removeLuaSprite('ResultEnter');
        removeLuaSprite('ResultMainRank');
        if ResultScreenDebug then
            removeLuaSprite('Screenshots');
        end
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