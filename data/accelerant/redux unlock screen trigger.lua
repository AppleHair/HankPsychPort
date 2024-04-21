function onCreate()
    if not isStoryMode then
        close();
        return;
    end
    makeAnimatedLuaSprite("ReduxUnlock", "menucharacters/AccelerantRedux", 0, 0);
    addAnimationByPrefix("ReduxUnlock", "idle-loop", "accelerantRedux", 24, true);
    setProperty("ReduxUnlock.offset.x", -50);
    setProperty("ReduxUnlock.offset.y", -30);
    triggerEvent("Signal-Enable Unlocked Screen", "ReduxUnlock", "");
    triggerEvent("Signal-Set Unlock Screen Color", "#BF2D2E", "");
end