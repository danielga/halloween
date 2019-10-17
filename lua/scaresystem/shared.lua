game.AddParticles("particles/conc_stars.pcf")
PrecacheParticleSystem("yikes_fx")

game.AddParticles("particles/scary_ghost.pcf")
PrecacheParticleSystem("ghost_glow")

local PLAYER = FindMetaTable("Player")

function PLAYER:IsScared()
	return self:GetNWBool("scared", false)
end

if CLIENT then
	include("client.lua")
else
	include("server.lua")
end
