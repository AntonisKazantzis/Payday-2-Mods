local AI_State = managers.groupai:state()
local convert_hostage_to_criminal = AI_State.convert_hostage_to_criminal

function PlayerManager:convert_enemies_max_minions()
    return 999
end

function convertall()
    local all_enemies = managers.enemy:all_enemies()

    for _, ud in pairs(all_enemies) do
        local unit = ud.unit
        if not unit:brain()._logic_data.is_converted then
            pcall(convert_hostage_to_criminal, AI_State, unit)
        end
    end
end

convertall()