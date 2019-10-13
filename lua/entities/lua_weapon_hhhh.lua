AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Author = "MetaMan"
ENT.PrintName = "Horseless Headless Horsemann's Headtaker"

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.AutomaticFrameAdvance = true

ENT.PhysgunDisabled = true
ENT.m_tblToolsAllowed = {}

function ENT:CanConstruct()
	return false
end

function ENT:CanTool()
	return false
end

function ENT:Initialize()
	self:SetModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
end
