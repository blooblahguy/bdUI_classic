local bdUI, c, l = unpack(select(2, ...))
local mod = bdUI:get_module("Unitframes")

mod.custom_layout["target"] = function(self, unit)
	local config = mod.save
	
	self:SetSize(config.playertargetwidth, config.playertargetheight)
	
	mod.additional_elements.power(self, unit)
	mod.additional_elements.castbar(self, unit, "right")
	mod.additional_elements.buffs(self, unit)
	mod.additional_elements.debuffs(self, unit)

	self.Power:SetHeight(config.playertargetpowerheight)
	self.Power:Show()
	if (config.playertargetpowerheight == 0) then
		self.Power:Hide()
	end
	self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, config.playertargetpowerheight + bdUI.border)

	mod.version = bdUI:get_game_version()

	self.Debuffs.initialAnchor = "BOTTOMLEFT"
	self.Debuffs.size = 22
	self.Debuffs['growth-x'] = "RIGHT"
	self.Debuffs.CustomFilter = function(element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll)
		isBossDebuff = isBossDebuff or false
		nameplateShowAll = nameplateShowAll or false
		duration, expiration = bdUI:update_duration(button.cd, unit, spellID, caster, name, duration, expiration)
		local castByPlayer = caster and UnitIsUnit(caster, "player") or false

		if (castByPlayer and (duration ~= 0 and duration < 300)) then
			if (bdUI:filter_aura(name, casterIsPlayer, isBossDebuff, nameplateShowAll, true)) then
				return true
			end
		end
	end
	
	self.Buffs:ClearAllPoints()

	if (config.uf_buff_target_match_player) then
		self.Buffs:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
		self.Buffs:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 4)
		self.Buffs:SetSize(config.playertargetwidth, 60)
		self.Buffs.size = config.uf_buff_size
		self.Buffs['growth-x'] = "RIGHT"
		self.Buffs.initialAnchor  = "BOTTOMLEFT"
	else
		self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 7, 2)
		self.Buffs:SetSize(80, 60)
		self.Buffs.size = 12
	end

	self.Buffs.CustomFilter = function(element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll)
		isBossDebuff = isBossDebuff or false
		nameplateShowAll = nameplateShowAll or false

		-- allow it if it's tracked in the ui and not blacklisted
		if ( bdUI:filter_aura(name, casterIsPlayer, isBossDebuff, nameplateShowAll, true) ) then
			return true
		end
		-- also allow anything that might be casted by the boss
		if (not caster and not UnitIsPlayer("target")) then
			return true
		end
		-- look for non player casters
		if (caster and not strfind(caster, "raid") and not strfind(caster, "party") and not caster == "player") then
			return true
		end
	end
	

	mod.align_text(self, "right")
end
