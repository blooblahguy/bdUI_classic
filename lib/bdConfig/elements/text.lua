local parent, ns = ...
local lib = ns.bdConfig

--========================================
-- Methods Here
--========================================
local methods = {
	
}

--========================================
-- Spawn Element
--========================================
local function create(options, parent)
	options.size = options.size or "full"
	local container = lib:create_container(options, parent, 16)

	local text = container:CreateFontString(nil, "OVERLAY", "bdConfig_font")

	text:SetText(options.value or options.label)
	text:SetAlpha(0.8)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("TOP")
	text:SetAllPoints(container)

	local lines = math.ceil(text:GetStringWidth() / (container:GetWidth() - 4))

	container:SetHeight( (lines * 14) + 10)

	return container, text
end

lib:register_element("text", create)