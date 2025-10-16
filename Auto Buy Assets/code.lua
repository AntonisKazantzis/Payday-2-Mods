Hooks:PostHook(MissionBriefingGui, "create_asset_tab", "REBuyAssets_AutoBuy", function()
	local asset_ids = managers.assets:get_all_asset_ids(true) or {}
	for _, asset_id in pairs(asset_ids) do
		local asset = managers.assets:_get_asset_by_id(asset_id)
		if asset and asset.can_unlock then
			managers.assets:unlock_asset(asset_id)
		end
	end
end)
