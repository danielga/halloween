ENT.Base = "base_nextbot"
ENT.Author = "MetaMan"
ENT.PrintName = "Ghost (NextBot)"

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.AutomaticFrameAdvance = true

ENT.PhysgunDisabled = true
ENT.m_tblToolsAllowed = {}

local boo = "vo/halloween_boo%i.mp3" -- 1 to 7
local haunted = "vo/halloween_haunted%i.mp3" -- 1 to 5
local moan = "vo/halloween_moan%i.mp3" -- 1 to 4

function ENT:CanConstruct()
	return false
end

function ENT:CanTool()
	return false
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and not ent:IsScared() then
		if SERVER then
			self:EmitSound(string.format(boo, math.random(1, 7)), 511)
		end

		ent:SetScared(true, 5)
	end
end

function ENT:Think()
	if SERVER and self:Health() > 0 and CurTime() > self.__sound then
		self:EmitSound(string.format(moan, math.random(1, 4)))
		self.__sound = CurTime() + math.random(15, 45)
	end

	local min, max = self:WorldSpaceAABB()
	local plys = ents.FindInBox(min, max)
	for i = 1, #plys do
		if plys[i]:IsPlayer() then
			self:StartTouch(plys[i])
		end
	end
end
