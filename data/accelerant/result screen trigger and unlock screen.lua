function onCreate()
    close();
    triggerEvent("Signal-Trigger OVS Results");
    if not isStoryMode then
        return;
    end
    makeAnimatedLuaSprite("ReduxUnlock", "menucharacters/AccelerantRedux", 0, 0);
    addAnimationByPrefix("ReduxUnlock", "idle-loop", "accelerantRedux", 24, true);
    setProperty("ReduxUnlock.offset.x", -50);
    setProperty("ReduxUnlock.offset.y", -30);
    triggerEvent("Signal-Add Unlocked Screen", "ReduxUnlock", "");
    triggerEvent("Signal-Set Unlocked Screen Color", "#BF2D2E", "");
end