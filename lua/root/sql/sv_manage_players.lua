local players = players or {} // connected players list

local mySql = getMySqlInstance() // get the sql instance

util.AddNetworkString("timeplayed")

local updateInterval = 60 // update database every x seconds

local function updateClient(ply, time)
    net.Start("timeplayed")
    net.WriteUInt(time, 21)
    net.Send(ply)

    print("sent client update for player " .. ply:SteamID())
end

local function init() 
    local allPlayers = player.GetAll()
    if allPlayers then
        for k, ply in ipairs(allPlayers) do
            if not players[ply] then
                players[ply] = mySql.getPlayerTime(ply)
            end
            updateClient(ply, mySql.getPlayerTime(ply))
        end
    end
end
init()

// every time a player connects, add him to the connected players list
hook.Add("PlayerSpawn", "handle_player_spawn", function(ply)
    if not mySql.playerExists(ply) then
        // create new player
        mySql.addPlayer(ply) 
    end
    // add the player to the connected players list
    players[ply] = mySql.getPlayerTime(ply) 

    updateClient(ply, players[ply]) // initial client update to show the right time

    // for each connected player create a unique timer
    if not timer.Exists(ply:SteamID()) then 
        timer.Create(ply:SteamID(), updateInterval, 0, function()
            local newTime = players[ply] + updateInterval
            
            mySql.updatePlayer(ply, newTime)
            updateClient(ply, newTime)
            
            players[ply] = newTime

            print("Server time " .. players[ply])
        end)
    end
end)


// handle player dc from server
hook.Add("PlayerDisconnected", "handle_player_dc", function(ply)
    // update database before player dc
    mySql.updatePlayer(ply, players[ply])
    
    // remove existing timer 
    if timer.Exists(ply:SteamID()) then timer.Remove(ply:SteamID()) end

    // remove player from players table
    local keysTable = table.GetKeys(players)
    for key, _ply in ipairs(keysTable) do
        if _ply == ply then
            table.remove(players, key)
        end
    end
end)