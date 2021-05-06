local players = players or {} // connected players list

util.AddNetworkString("timeplayed")

// every time a player connects, add him to the connected players list
hook.Add("PlayerSpawn", "handle_player_spawn", function(ply)
    if not playerExists(ply) then
        addPlayer(ply)
    end

    players[ply] = getPlayerTime(ply)
end)


// handle player dc from server
hook.Add("PlayerDisconnected", "handle_player_dc", function(ply)
    // if there's a player to remove from the list
    if (IsValid(players[ply])) then
        players[ply] = nil
    end
end)

local function updateClient(ply, time)
    net.Start("timeplayed")
    net.WriteUInt(time, 21)
    net.Send(ply)
end

local nextThink = 0
local updateInterval = 1 // update database every x seconds
hook.Add("Think", "handle_twog_update", function()
    if RealTime() > nextThink then
        nextThink = RealTime() + updateInterval // every x seconds update database

        for ply, time in pairs(players) do
            if time ~= nil then // player is connected
                local newTime = time + updateInterval

                updatePlayer(ply, newTime) // update the database
                updateClient(ply, newTime) // send a net message to the client

                players[ply] = newTime
            end
        end

        PrintTable(players)
    end
end)