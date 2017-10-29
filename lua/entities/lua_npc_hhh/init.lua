AddCSLuaFile("client.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local boo = "vo/halloween_boss/knight_alert.mp3"
local alert = "vo/halloween_boss/knight_alert0%i.mp3" -- 1 to 2
local attack = "vo/halloween_boss/knight_attack0%i.mp3" -- 1 to 4
local death = "vo/halloween_boss/knight_death0%i.mp3" -- 1 to 2
local dying = "vo/halloween_boss/knight_dying.mp3"
local laugh = "vo/halloween_boss/knight_laugh0%i.mp3" -- 1 to 4
local pain = "vo/halloween_boss/knight_pain0%i.mp3" -- 1 to 3
local spawn = "vo/halloween_boss/knight_spawn.mp3"

-- self:GetSequenceActivity(self:LookupSequence("sequence_name"))
-- most don't seem to correspond to real ACT_ enums
local ACT_STAND = 1192
local ACT_RUN_ITEM1 = 1194
local ACT_RUN_MELEE = 1173
local ACT_ATTACK_STAND = 1203

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

local pathopts = {draw = game.SinglePlayer(), repath = 0.1}

function ENT:Initialize()
	self:SetModel("models/bots/headless_hatman.mdl")
	self:SetHealth(9001)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetSolidMask(MASK_NPCWORLDSTATIC)
	self:SetCollisionBounds(Vector(-13, -13, 0), Vector(13, 13, 120))

	self.weapon = ents.Create("base_anim")
	self.weapon:SetModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
	self.weapon:SetParent(self)
	self.weapon:AddEffects(EF_BONEMERGE)
	self.weapon:Spawn()

	self.loco:SetDeathDropHeight(500)

	self.__sound = 0
end

function ENT:Think()
	if self:Health() > 0 and CurTime() > self.__sound then
		self:EmitSound(Format(laugh, math.random(1, 4)))
		self.__sound = CurTime() + math.random(15, 45)
	end
end

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if act == ACT_RUN_ITEM1 or act == ACT_RUN_MELEE then
		self:BodyMoveXY()
	end

	if self:GetCycle() >= 1 then
		self:SetCycle(0)
	end

	self:FrameAdvance()
end

function ENT:RunBehaviour()
	while true do
		local ply
		local entities = ents.FindInPVS(self)
		for i = 1, #entities do
			local ent = entities[i]
			if ent:IsPlayer() then
				ply = ent
				break
			end
		end

		if IsValid(ply) and ply:Alive() then
			self:StartActivity(ACT_RUN_ITEM1)
			self.loco:SetDesiredSpeed(360)
			self:ChaseTarget(ply, pathopts)
		else
			self:StartActivity(ACT_RUN_ITEM1)
			self.loco:SetDesiredSpeed(200)
			local pos = table.Random(walktable)
			self:MoveToPos(pos, pathopts)
		end

		coroutine.yield()
	end
end

function ENT:ChaseTarget(target, options)
	if not IsValid(target) then
		return "invalid"
	end

	local options = options or {}

	local path = Path("Chase")
	path:SetMinLookAheadDistance(options.lookahead or 300)
	path:SetGoalTolerance(options.tolerance or 20)
	path:Compute(self, target:GetPos())

	if not path:IsValid() then
		return "failed"
	end

	while path:IsValid() and target:IsValid() do
		path:Chase(self, target)

		if options.draw then
			path:Draw()
		end

		if self:GetPos():DistToSqr(target:GetPos()) <= 140 * 140 then
			self:Attack(target)
			break
		end

		if self.loco:IsStuck() then
			self:HandleStuck()
			return "stuck"
		end

		if options.maxage and path:GetAge() > options.maxage then
			return "timeout"
		end

		if options.repath and path:GetAge() > options.repath then
			path:Compute(self, target:GetPos())
		end

		coroutine.yield()
	end

	return "ok"
end

function ENT:Attack(ply)
	ply:Lock()

	self:EmitSound(string.format(attack, math.random(1, 4)))
	if self.__sound > CurTime() then
		self.__sound = self.__sound + 5
	end

	self:RestartGesture(ACT_ATTACK_STAND)

	coroutine.wait(0.5)

	ply:UnLock()

	local dmg = DamageInfo()
	dmg:SetAttacker(self)
	dmg:SetInflictor(self.weapon)
	dmg:SetDamageType(DMG_SLASH)
	dmg:SetDamage(2 ^ 31 - 1)
	dmg:SetMaxDamage(2 ^ 31 - 1)
	dmg:SetDamageForce(Vector(self:GetAngles():Forward() * 500))
	dmg:SetDamagePosition(ply:GetPos() + Vector(0, 0, 64))
	ply:TakeDamageInfo(dmg)
end

hook.Add("PlayerShouldTakeDamage", "Horseless Headless Horsemann damage", function(ply, att)
	if att:GetClass() == "lua_npc_hhh" then
		return true
	end
end)
