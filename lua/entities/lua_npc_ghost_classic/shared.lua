ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Author = "MetaMan"
ENT.PrintName = "Ghost"

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
