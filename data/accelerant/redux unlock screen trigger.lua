function onCreate()
    if not isStoryMode then
        close();
        return;
    end
    triggerEvent("Signal-Enable Unlocked Screen", "menucharacters/AccelerantRedux", "");
    triggerEvent("Signal-Set Unlock Screen Color", "#BF2D2E", "");
    triggerEvent("Signal-Set Unlock Object Offset", "50", "30");
    triggerEvent("Signal-Set Unlock Animation Prefix", "accelerantRedux", "");
end