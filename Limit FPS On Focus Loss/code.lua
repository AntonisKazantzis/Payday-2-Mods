FpsLimiter = FpsLimiter or {
    original_cap = nil,
    minimized_cap = 15,
    active = false,
    is_focused = true
}

-- Load the original FPS cap safely
function FpsLimiter:LoadOriginalCap()
    local cap = managers.user and managers.user:get_setting("fps_cap")
    self.original_cap = cap or 0
end

function FpsLimiter:OnFocusChanged(is_focused)
    if not managers.user then return end

    if not is_focused then
        Setup:set_fps_cap(self.minimized_cap)
        -- managers.user:set_setting("fps_cap", self.minimized_cap)
        self.active = true
    else
        Setup:set_fps_cap(self.original_cap)
        -- managers.user:set_setting("fps_cap", self.original_cap)
        self.active = false
    end
end

function FpsLimiter:Update()
    local is_focused = Application:in_focus()
    if is_focused ~= self.is_focused then
        self.is_focused = is_focused
        self:OnFocusChanged(is_focused)
    end
end

-- Initialize
FpsLimiter:LoadOriginalCap()

-- Hooks
Hooks:Add("GameSetupUpdate", "fl_update_gamesetup", callback(FpsLimiter, FpsLimiter, "Update"))
Hooks:Add("MenuUpdate", "fl_update_menu", callback(FpsLimiter, FpsLimiter, "Update"))
Hooks:Add("GameSetupPausedUpdate", "fl_update_gamesetuppaused", callback(FpsLimiter, FpsLimiter, "Update"))
