include("shared.lua")

if game.SinglePlayer() then
	local white = Color(255, 255, 255, 0)
	function ENT:Draw()
		self:DrawModel()
		debugoverlay.Box(self:GetPos(), self:OBBMins(), self:OBBMaxs(), 0.1, white)
	end
end
