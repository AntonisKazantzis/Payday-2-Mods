local Steam = Steam
local steam_uid = Steam.userid
local name = "Unknown" -- Spoof name here

function update_name()
	if not userid or userid == steam_uid(Steam) then
		return name
	else
		return name
	end
end

function update_name_spoof()
	local s = managers.network:session()
	if not s then
		return
	end
	
	local my_peer = s:local_peer()
	my_peer:set_name( name )
	
	for _, peer in pairs( s._peers ) do
		if not peer:loaded() or not my_peer:loaded() then
			peer:send( "request_player_name_reply", name )
		end
	end
end

update_name()
update_name_spoof()