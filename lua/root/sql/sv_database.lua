local MySql = MySql or {} // create a class

function getMySqlInstance() // I think it will create a singleton
    return MySql or nil
end

local table = table or ""

// create an sql table
function MySql.createTable(tableName)
    if sql.TableExists(tableName) then 
        table = tableName
        print("TABLE " .. tableName .. " ALREADY EXISTS")
        return 
    end

    sql.Query("CREATE TABLE IF NOT EXISTS " .. tableName .. " ( SteamID TEXT, time INTEGER )")
    table = tableName
end

function addPlayer(ply)
    local steamID = sql.SQLStr(ply:SteamID())
    
    sql.Query("INSERT INTO " .. table .. " ( SteamID, time ) VALUES( " .. steamID .. "," .. 0 .. ")")    
end

function MySql.updatePlayer(ply, time)
    local steamID = sql.SQLStr(ply:SteamID())

    sql.Query("UPDATE " .. table .. " SET time = " .. (time or 0) .. " WHERE SteamID = " .. steamID .. ";")
end


function MySql.playerExists(ply) 
    local steamID = sql.SQLStr(ply:SteamID())
    local query = sql.QueryValue("SELECT EXISTS( SELECT 1 FROM " .. table .. " WHERE SteamID = " .. steamID .. " );")

    return tobool(query)
end

function MySql.getPlayerTime(ply) 
    local steamID = sql.SQLStr(ply:SteamID())
    local query = sql.Query("SELECT time FROM " .. table .. " WHERE SteamID = " .. steamID .. ";")

    return tonumber(query[1]["time"] or 0)
end

function MySql.removePlayer(ply) 
    local steamID = sql.SQLStr(ply:SteamID())
    local query = sql.Query("DELETE FROM " .. table .. " WHERE SteamID = " .. steamID .. ";")

    return query
end

MySql.createTable("twog_table")