local cachedWords = {}
local playerCooldowns = {}
local wordConfig = {} -- Enter your words here
local cooldownTime = 5 * 60000 -- 5 minutes -- You can move this to the shared config

function StartHack(source)
  cachedWords[source] = wordConfig[math.random(#wordConfig)]
  local firstLetter, lastLetter = cachedWords[source]:sub(1, 1), cachedWords[source]:sub(-1, -1)
  TriggerClientEvent('bankhack:start', source, firstLetter, lastLetter)
end

RegisterNetEvent('bankhack:trigger', function()
  if cachedWords[source] then return print(source .. ' has already started a hack') end
  if playerCooldowns[source] and GetGameTimer() < playerCooldowns[source] then return print(source .. ' is on cooldown') end
  StartHack(source)
end)

RegisterNetEvent('bankhack:check', function(input)
  if not cachedWords[source] then return print('ban ' .. source) end
  if input ~= cachedWords[source] then
    TriggerClientEvent('bankhack:failed', source)
    return StartHack(source)
  end

  TriggerClientEvent('bankhack:success', source)
  playerCooldowns[source] = GetGameTimer() + cooldownTime
  cachedWords[source] = nil

  -- Reward here
end)

-- To start a hack, use TriggerServerEvent('bankhack:trigger') from the client
