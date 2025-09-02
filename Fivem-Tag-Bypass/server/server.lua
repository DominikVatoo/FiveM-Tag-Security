local ESX = nil
local bypass = {}

local BYPASS_CONFIG = {
    "license:cb334ee5a362f12798e0d2f5e2e41515812499e1", -- Dominik
    "license:dfc2d8fea2b5bed03450d4bd9075ea74ed6510f2", -- Cxby
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    for _, license in pairs(BYPASS_CONFIG) do 
        bypass[license] = true
    end
end)

-- Befehl: /addbp [ID]
RegisterCommand("addbp", function(s, a)
    if s == 0 then 
        local target = tonumber(a[1])
        if target ~= nil then 
            local license = nil
            for _, id in ipairs(GetPlayerIdentifiers(target)) do
                if string.sub(id, 1, 8) == "license:" then
                    license = id
                    break
                end
            end
            if license then
                bypass[license] = true
                print("Bypass added for " .. license)
            else
                print("No license identifier found for target player.")
            end
        else
            print("Usage: /addbp [id]")
        end
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(source, playerData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        local myName = GetPlayerName(src)
        local license = nil
        for _, id in ipairs(GetPlayerIdentifiers(src)) do
            if string.sub(id, 1, 8) == "license:" then
                license = id
                break
            end
        end

        -- Debug-Ausgabe
        -- print("[FL-Check] Spieler:", myName)
        -- print("[FL-Check] License:", license)
        -- print("[FL-Check] HasBypass:", tostring(HasBypass(license)))
        -- print("[FL-Check] Bypass-Liste:")
        for k in pairs(bypass) do print("  » " .. k) end

        if xPlayer.getGroup() ~= "user"
            and not string.find(string.lower(myName), "fl")
            and not string.find(string.lower(myName), "flashlife") then
            
            if not HasBypass(license) then
                DropPlayer(src, "FlashLife: Bitte füge das Team-Tag in deinen Steamnamen ein! => FL oder FLASHLIFE | " .. myName)
            end
        end
    end
end)

function HasBypass(license)
    return bypass[license] == true
end


-- MySQL.ready(function()
--     MySQL.Async.fetchAll("SELECT identifier, accounts FROM users", {}, function(users)
--         for _, user in ipairs(users) do
--             local accounts = json.decode(user.accounts)

--             if accounts then
--                 accounts.money = 0
--                 accounts.black_money = 0
--                 accounts.bank = 50000

--                 local newAccounts = json.encode(accounts)

--                 MySQL.Async.execute("UPDATE users SET accounts = @accounts WHERE identifier = @identifier", {
--                     ['@accounts'] = newAccounts,
--                     ['@identifier'] = user.identifier
--                 }, function(rowsChanged)
--                     print(("Accounts zurückgesetzt für %s"):format(user.identifier))
--                 end)
--             end
--         end
--     end)
-- end)