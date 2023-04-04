---@diagnostic disable: lowercase-global, unused-local


--[[ CALLBACKS ]]--
--[[
    onTaunt(number: 1|2|3|4, character: "boyfriend" | "dad")
    onReceive(message: string)
]]--

--[[ VARIABLES ]]--
--- If you are hosting in online multiplayer
---@type boolean
Hosting = nil;
--- If you are the opponent
---@type boolean
leftSide = nil;
--- If you are in local multiplayer
---@type boolean
localPlay = nil;
--- If you are in online multiplayer
---@type boolean
onlinePlay = nil;

--[[ FUNCTIONS ]]--
---sends `message` to the connected[non-host] player
---@param message string A message string to send
function send(message) end
---@alias characters "boyfriend" | "dad"
---Resizes a character
---@param character characters The character to resize
---@param size number The new size for the character
function characterRezise(character, size) end
---flips a character from left to right and contrarily
---@param character characters The character to flip
function characterFlip(character) end -- only for custom characters!