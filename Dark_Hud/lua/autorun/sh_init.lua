if SERVER then
    AddCSLuaFile("client/cl_hud.lua")
    AddCSLuaFile("sh_config.lua")
end

if CLIENT then
    include("sh_config.lua")
    include("client/cl_hud.lua")
end
