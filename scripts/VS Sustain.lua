function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length')-1 do
        -- we check if the note is an Sustain Note
        if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
            -- we make the note a no animation note
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
        end
    end
end

-- the way we set the character's hold timer to 0 every time
-- a sustain note is being hit helps us hold the sing animation
-- until the sustain is over

function goodNoteHit(id, direction, noteType, isSustainNote)
    -- we check if the note is an Sustain Note
    if isSustainNote then
        -- we check if the note is an gf note of some kind
        if getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
            setProperty('gf.holdTimer', 0);
        else
            setProperty('boyfriend.holdTimer', 0);
        end
    end
end


function opponentNoteHit(id, direction, noteType, isSustainNote)
    -- we check if the note is an Sustain Note
    if isSustainNote then
        -- we check if the note is an gf note of some kind
        if getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
            setProperty('gf.holdTimer', 0);
        else
            setProperty('dad.holdTimer', 0);
        end
    end
end

-- You know, I don't know if I can even call this script the 
-- VS. Sustain script anymore.
-- 
-- From the research I've done, I found out that
-- there are three types of sustain note animations in FNF ONLINE VS:
-- 
-- 1) the animation holder - This one is the type that this script is trying to emulate.
--              It plays the sing animation once, and holds it until the end of the sustain
--              part of the note. Only then, it lets the character go back to his idle animation.
-- 
-- 2) the animation looper - This type is very similar to the holder, but instead of holding the
--              animation normally, It lets the sing animation loop on itself for the whole duration
--              of the hold 𝘄𝗶𝘁𝗵𝗼𝘂𝘁 𝗱𝗲𝗽𝗲𝗻𝗱𝗶𝗻𝗴 𝗼𝗻 𝘁𝗵𝗲 𝗯𝗲𝗮𝘁 𝗶𝗻 𝗮𝗻𝘆 𝘄𝗮𝘆. I really don't know why they did
--              this when they already have the next type.
--
-- 3) the animation player - As opposed to the animation looper, in this type the sing animation is being played
--              again and again for every time a sustain note unit that is included in the chart is being hit,
--              which means the rate that the sing animations are being played at 𝗱𝗲𝗽𝗲𝗻𝗱𝘀 𝗼𝗻 𝘁𝗵𝗲 𝗯𝗲𝗮𝘁. 
--              sometimes, the sing animations play so fast that it looks like it's stuck on the first frame.
--              This type is very similer to the way sustain notes animate in the base game, the engines and most of the mods,
--              but I can't know for sure if it's the same, because I don't have access to FNF ONLINE VS' source code.
--              maybe they intentionally hold the animation on the first frame. idk.
-- 
-- every character in FNF ONLINE VS. animates the sustain notes in a different way
-- heres a list of all of the characters and the types they use according to my research:
-- 
-- Hank (Accelerant) - Holder
-- Tricky (Accelerant) - Holder
-- Boyfriend (Accelerant) - Looper
-- Pico (Unloaded) - Looper
-- Überkids (Unloaded) - Unknown (never hits a sustain note)
-- Edd (Challeng-Edd) - Player
-- Edd-Angry (Challeng-Edd) - Player
-- Edd-Corner (Challeng-Edd) - Player
-- Eduardo (Challeng-Edd) - Player
-- Tord (Challeng-Edd) - Player
-- Boyfriend (Challeng-Edd) - Holder
-- Boyfriend-Corner (Challeng-Edd) - Holder
--
-- Another thing I found out about through my research is that all of boyfriend's sing
-- animations in every boyfriend character in FNF ONLINE VS. 𝗲𝘅𝗰𝗲𝗽𝘁 𝗳𝗼𝗿 𝘀𝗶𝗻𝗴𝗗𝗢𝗪𝗡 are 𝗿𝗲𝘃𝗲𝗿𝘀𝗲𝗱, and that's why
-- they look strange.
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- I can already see the nerd emojis.