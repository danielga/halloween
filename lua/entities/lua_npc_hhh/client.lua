include("shared.lua")

if game.SinglePlayer() then
	function ENT:Draw()
		self:DrawModel()
		debugoverlay.Box(self:GetPos(), self:OBBMins(), self:OBBMaxs(), 0.1, Color(255, 255, 255, 0))
	end
end
