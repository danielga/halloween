AddCSLuaFile("client.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local pathopts = {draw = true, repath = 1}

function ENT:Initialize()
	self:SetModel("models/props_halloween/ghost.mdl")
	self:SetNotSolid(true)
	self:SetTrigger(true)
	self:SetHealth(9001)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetSolidMask(MASK_NPCWORLDSTATIC)
	self:SetCollisionBounds(Vector(-13, -13, 20), Vector(13, 13, 90))

	self.loco:SetDesiredSpeed(128)
	self.loco:SetDeathDropHeight(2048)
	self.loco:SetJumpHeight(256)
	self.loco:SetStepHeight(32)

	self.__delay = 0
	self.__sound = 0
end

function ENT:RunBehaviour()
	while true do
		self:StartActivity(ACT_RUN)
		local maxheight = self.loco:GetJumpHeight()
		local walktable = navmesh.Find(self:GetPos(), 2048, maxheight, maxheight)
		if #walktable == 0 then
			coroutine.wait(1)
			continue
		end

		local area = table.Random(walktable)
		if area == nil then
			coroutine.wait(1)
			continue
		end

		local pos = area:GetRandomPoint()
		self:MoveToPos(pos, pathopts)

		coroutine.wait(3)
	end
end

function ENT:OnInjured(dmginfo)
	dmginfo:SetDamage(0)
	dmginfo:SetDamageType(DMG_GENERIC)
end
