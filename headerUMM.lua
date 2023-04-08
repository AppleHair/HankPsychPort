---@diagnostic disable: lowercase-global, unused-local


----------------------------------------------------------------------------------
    	-- Callbacks --
----------------------------------------------------------------------------------

--[[
    onTaunt(number: 1|2|3|4, character: "boyfriend" | "dad")
    onReceive(message: string)
    onGameSet(winner: string, forfeit: boolean)
    onResultScreen()
    onResultStats(left: table, right: table)
        [1] - name: string 
        [2] - accuracy: number
        [3] - misses: number
        [4] - score: number
        [5] - average: number
]]--

----------------------------------------------------------------------------------
    	-- Variables --
----------------------------------------------------------------------------------

---True if you are hosting in online\
---multiplayer, and false otherwise.
---@type boolean
Hosting = nil;

---True if you are the opponent,\
---and false otherwise.
---@type boolean
leftSide = nil;

---True if you are in local multiplayer,\
---and false otherwise.
---@type boolean
localPlay = nil;

---True if you are in online multiplayer,\
---and false otherwise.
---@type boolean
onlinePlay = nil;

----------------------------------------------------------------------------------
    	-- Functions --
----------------------------------------------------------------------------------

---Sends `message` to the other connected\
---player in online multiplayer.
---@param message string A message string to send
function send(message) end

---Sets `character`'s scale to `size`.
---@param character "boyfriend" | "dad" The character to resize
---@param size number The new size for the character
function characterRezise(character, size) end

---Flips `character` horizontally while\
---making sure all animations are offsetted correctly.\
---(Only works on custom characters due to the use of left and right .json files)
---@param character "boyfriend" | "dad" The character to flip
function characterFlip(character) end