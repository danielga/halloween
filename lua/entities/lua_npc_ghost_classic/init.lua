AddCSLuaFile("shared.lua")
include("shared.lua")

local function LandmarkVector(x, y, z)
	return Vector(x, y, z)
end

if pcall(require, "landmark") and LMVector then
	LandmarkVector = function(x, y, z, landmark)
		local lmvector = LMVector(x, y, z, landmark, true)
		if lmvector then
			return lmvector:pos()
		end
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

local boo = "vo/halloween_boo%i.mp3" -- 1 to 7
local haunted = "vo/halloween_haunted%i.mp3" -- 1 to 5
local moan = "vo/halloween_moan%i.mp3" -- 1 to 4

function ENT:Initialize()
	self:SetModel("models/Humans/Group01/male_02.mdl")
	self:SetNoDraw(true)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetTrigger(true)
	self:CapabilitiesAdd(bit.bor(CAP_USE, CAP_AUTO_DOORS, CAP_OPEN_DOORS, CAP_MOVE_GROUND))
	self:SetMaxYawSpeed(20)
	self:SetHealth(100)
	self:SetNPCState(NPC_STATE_IDLE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetNotSolid(true)

	local ghost = ents.Create("base_anim")
	ghost:SetModel("models/props_halloween/ghost.mdl")
	ghost:SetPos(self:GetPos())
	ghost:SetAngles(self:GetAngles())
	ghost:SetParent(self)
	ghost:Spawn()

	self.__delay = 0
	self.__sound = 0
end

function ENT:Think()
	if GetConVarNumber("ai_disabled") ~= 0 then
		return
	end

	if self:GetNPCState() == NPC_STATE_IDLE and CurTime() > self.__sound then
		self:EmitSound(string.format(moan, math.random(1, 4)))
		self.__sound = CurTime() + math.random(15, 45)
	end

	if self:GetNPCState() ~= NPC_STATE_DEAD and CurTime() > self.__delay then
		if self:GetNPCState() ~= NPC_STATE_IDLE then
			self:SetNPCState(NPC_STATE_IDLE)
		end

		local ang = self:GetAngles() -- fix funny walking
		ang.p = 0
		ang.r = 0
		self:SetAngles(ang)
		self:SelectSchedule()
	end
end

function ENT:SelectSchedule()
	if self:GetNPCState() ~= NPC_STATE_IDLE then
		return
	end

	self:SetLastPosition(table.Random(walktable) + Vector(0, 0, 40))
	self:SetSchedule(math.random(1, 10) == 5 and SCHED_FORCED_GO_RUN or SCHED_FORCED_GO)
	self.__delay = CurTime() + 10
end

function ENT:StartTouch(ent)
	if IsValid(ent) and ent:IsPlayer() and not ent:IsScared() then
		self:EmitSound(string.format(boo, math.random(1, 7)), 511)
		ent:SetScared(true, 5)
	end
end
