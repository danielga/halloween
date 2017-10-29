AddCSLuaFile("client.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local function LandmarkVector(x, y, z)
	return Vector(x, y, z)
end

if pcall(require, "landmark") and LMVector then
	LandmarkVector = function(x, y, z, landmark)
		return LMVector(x, y, z, landmark, true):pos()
	end
end

local walktable = {
	LandmarkVector(-115, 982, -41, "ccal"),
	LandmarkVector(-377, -120, -8, "lobby"),
	LandmarkVector(-486, 258, -56, "land_theater"),
	LandmarkVector(-347, -5, -8, "sauna"),
	LandmarkVector(-425, -1065, -672, "blkbx"),
	LandmarkVector(-18, -542, -520, "blkbx"),
	LandmarkVector(-772, 1446, -8, "lobby"),
	LandmarkVector(16, 7, -8, "minigame"),
	LandmarkVector(-787, 2068, -8, "lobby")
}

local pathopts = {draw = game.SinglePlayer(), repath = 0.1}

function ENT:Initialize()
	self:SetModel("models/props_halloween/ghost.mdl")
	self:SetNotSolid(true)
	self:SetTrigger(true)
	self:SetHealth(9001)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetSolidMask(MASK_NPCWORLDSTATIC)
	self:SetCollisionBounds(Vector(-20, -20, 20), Vector(20, 20, 90))

	self.loco:SetDesiredSpeed(120)
	self.loco:SetDeathDropHeight(500)

	self.__delay = 0
	self.__sound = 0
end

function ENT:RunBehaviour()
	while true do
		self:StartActivity(ACT_RUN)
		local pos = table.Random(walktable)
		self:MoveToPos(pos, pathopts)

		coroutine.yield()
	end
end

function ENT:OnInjured(dmginfo)
	dmginfo:SetDamage(0)
	dmginfo:SetDamageType(DMG_GENERIC)
end
