-- Store the desired name to spoof
local spoofed_name = "Unknown"

-- Force our name whenever asked
local orig_name = NetworkPeer.name
function NetworkPeer:name()
    if self == managers.network:session():local_peer() then
        return spoofed_name
    end
    return orig_name(self)
end

-- Force set_name to keep spoofed for local peer
local orig_set_name = NetworkPeer.set_name
function NetworkPeer:set_name(name, ...)
    if self == managers.network:session():local_peer() then
        return orig_set_name(self, spoofed_name, ...)
    end
    return orig_set_name(self, name, ...)
end

-- Apply spoof when a peer is added
Hooks:PostHook(NetworkManager, "on_peer_added", "SpoofOnPeerAdded", function(self, peer, peer_id)
    local session = managers.network:session()
    if not session then
        return
    end

    local local_peer = session:local_peer()
    if peer == local_peer then
        peer:set_name(spoofed_name)
    end
end)
