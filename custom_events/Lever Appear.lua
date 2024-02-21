
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
end