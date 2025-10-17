if not _PlayerTweakData_init then _PlayerTweakData_init = PlayerTweakData.init end
function PlayerTweakData:init()
    _PlayerTweakData_init(self)
    
    self.player.put_on_mask_time = 0
end