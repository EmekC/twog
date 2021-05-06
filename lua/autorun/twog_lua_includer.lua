local rootDir = "root"

local function addFile(myFile, dir)
    local filePrefix = string.lower(string.Left(myFile, 3))

    if SERVER and filePrefix == "sv_" then
        print("[autoload] including serverside file: " .. myFile)
        include(dir..myFile)

    elseif filePrefix == "sh_" then
        if SERVER then
            print("[autoload] adding cs shared file: " .. myFile)
            AddCSLuaFile(dir..myFile)
        end
        
        print("[autoload] including shared file: " .. myFile)
        include(dir..myFile)

    elseif filePrefix == "cl_" then
        if SERVER then
            print("[autoload] adding cs client file: " .. myFile)
            AddCSLuaFile(dir..myFile)
        elseif CLIENT then
            print("[autoload] including client file: " .. myFile)
            include(dir..myFile)
        end

    end

end

local function includeDir(dir) 
    dir = dir .. "/"

    local myFile, myDir = file.Find(dir.."*", "LUA")

    for _, v in ipairs(myFile) do
        if string.EndsWith(v, ".lua") then
            print("[AUTOLOAD] adding file " .. v)
            addFile(v, dir)
        end
    end

    for _, v in ipairs(myDir) do
        print("[AUTOLOAD] adding directory " .. v)
        includeDir(dir..v)
    end
end

includeDir(rootDir)