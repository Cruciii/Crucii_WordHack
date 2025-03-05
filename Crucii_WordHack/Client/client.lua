
-- Store the current word challenge
local currentWord = nil

-- Helper function to generate puzzle text (first letter, underscores, last letter)
local function generatePuzzle(word)
    if #word < 2 then
        return word
    end
    local first = string.sub(word, 1, 1)
    local last = string.sub(word, -1)
    local underscores = string.rep(" _ ", #word - 2)
    return first .. underscores .. last
end
--Event to start the hack
RegisterNetEvent("bankhack:trigger", function()
    math.randomseed(GetGameTimer())
    local words = Config.Words
    local index = math.random(#words)
    currentWord = words[index]
    local puzzle = generatePuzzle(currentWord)

    print("[myBankHack] Selected word: " .. tostring(currentWord))
    print("[myBankHack] Puzzle: " .. puzzle)

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "setPuzzle",
        puzzle = puzzle,
        instruction = "Enter the full word matching the pattern below:"
    })
end)

-- Command to trigger the bank hack challenge

RegisterCommand("bankhack", function()
    math.randomseed(GetGameTimer())
    local words = Config.Words
    local index = math.random(#words)
    currentWord = words[index]
    local puzzle = generatePuzzle(currentWord)

    print("[myBankHack] Selected word: " .. tostring(currentWord))
    print("[myBankHack] Puzzle: " .. puzzle)

    -- Open the NUI terminal and send the puzzle data
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "setPuzzle",
        puzzle = puzzle,
        instruction = "Enter the full word matching the pattern below:"
    })
end)

-- Callback when the player submits their guess from the NUI
RegisterNUICallback("submit", function(data, cb)
    local guess = data.guess:lower()
    if guess:lower() == currentWord:lower() then
        -- Notify the NUI of success
        SendNUIMessage({
            action = "result",
            success = true,
            message = "Access Granted: Word Correct!"
        })
        -- Trigger an event that other scripts can listen to
        TriggerEvent("bankhack:correct")
        Citizen.SetTimeout(1000, function()
            SetNuiFocus(false, false)
            SendNUIMessage({ action = "hide" })
        end)
    else
        SendNUIMessage({
            action = "result",
            success = false,
            message = "Access Denied: Incorrect Word! Try again."
        })
    end
    cb("ok")
end)

-- Callback to handle when the timer expires
RegisterNUICallback("timeout", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)