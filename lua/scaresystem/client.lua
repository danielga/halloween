local isscared = false
local hasghost = false
local distance = 9000

hook.Add("Think", "Scare System", function()
	local localplayer = LocalPlayer()

	isscared = localplayer:IsScared()
	hasghost = false
	distance = 9000

	local ghosts = ents.FindByClass("lua_npc_ghost")
	for i = 1, #ghosts do
		if not ghosts[i]:IsDormant() then
			local dist = localplayer:GetPos():Distance(ghosts[i]:GetPos())
			if dist <= 200 and dist < distance then
				hasghost = true
				distance = dist
			end
		end
	end
end)

local scared_modify =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0.1,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local ghost_modify =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects", "Scare System", function()
	if isscared then
		DrawColorModify(scared_modify)
	elseif hasghost then
		ghost_modify["$pp_colour_colour"] = distance / 200
		DrawColorModify(ghost_modify)
	end
end)

hook.Add("CalcView", "Scare System", function(ply, pos, angles, fov, nearz, farz)
	if isscared then
		local forward = angles:Forward()
		local endpos = pos - forward * 200
		local trace = util.TraceLine({start = pos, endpos = endpos, filter = ply, mask = MASK_SOLID_BRUSHONLY})
		return {origin = trace.Hit and trace.HitPos + forward * 5 or endpos}
	end
end)

hook.Add("ShouldDrawLocalPlayer", "Scare System", function(ply)
	if isscared then
		return true
	end
end)

local PLAYER = FindMetaTable("Player")

function PLAYER:SetScared()
end
