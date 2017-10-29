ENT.Base = "base_nextbot"
ENT.Author = "MetaMan"
ENT.PrintName = "Headless Horseless Horsemann (NextBot)"

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
