AddCSLuaFile("shared.lua")
AddCSLuaFile("client.lua")

local stop_queue = {}
local next_think = 0

hook.Add("Think", "Scare System", function()
	local curtime = CurTime()
	if curtime >= next_think then
		next_think = curtime + 0.2
		for ply, data in pairs(stop_queue) do
			if not IsValid(ply) then
				stop_queue[ply] = nil
			elseif curtime >= data.endtime then
				ply:SetScared(false)
			end
		end
	end
end)

hook.Add("PlayerSpawn", "Scare System", function(ply)
	if ply:IsScared() then
		ply:SetScared(false, nil, true)
	end
end)

local PLAYER = FindMetaTable("Player")

local scream = "vo/halloween_scream%i.mp3" -- 1 to 8
function PLAYER:SetScared(bool, time, dont_touch_speeds)
	if bool then
		if not stop_queue[self] and not dont_touch_speeds then
			stop_queue[self] = {
				endtime = CurTime() + time,
				runspeed = self:GetRunSpeed(),
				walkspeed = self:GetWalkSpeed(),
				crouchedspeed = self:GetCrouchedWalkSpeed(),
				canwalk = self:GetCanWalk()
			}
		elseif stop_queue[self] then
			stop_queue[self].endtime = CurTime() + time
		end

		self:EmitSound(scream:format(math.random(1, 8)))
		self:SetRunSpeed(120)
		self:SetWalkSpeed(70)
		self:SetCrouchedWalkSpeed(0.1)
		self:SetCanWalk(false)

		self:SetNetworkedBool("scared", true)

		local attach = self:LookupAttachment("eyes")
		if attach == -1 then
			local min, max = self:GetModelRenderBounds()
			ParticleEffect("yikes_fx", max.z - min.z, Angle(0, 0, 0), self)
		else
			ParticleEffectAttach("yikes_fx", PATTACH_POINT_FOLLOW, self, attach)
		end
	else
		if stop_queue[self] and not dont_touch_speeds then
			self:SetRunSpeed(stop_queue[self].runspeed)
			self:SetWalkSpeed(stop_queue[self].walkspeed)
			self:SetCrouchedWalkSpeed(stop_queue[self].crouchedspeed)
			self:SetCanWalk(stop_queue[self].canwalk)
		end

		stop_queue[self] = nil

		self:SetNetworkedBool("scared", false)
		
		self:StopParticles()
	end
end
