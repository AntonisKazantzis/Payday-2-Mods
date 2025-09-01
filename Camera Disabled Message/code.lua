local original_set_detection_enabled = SecurityCamera.set_detection_enabled

local cameras_disabled = false

local function send_camera_disabled_message()
    if not cameras_disabled then
        managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "System", "Security cameras are disabled!")
        cameras_disabled = true
    end
end

function SecurityCamera:set_detection_enabled(state, settings, mission_element, ...)
    if not state then
        send_camera_disabled_message()
    end

    return original_set_detection_enabled(self, state, settings, mission_element, ...)
end