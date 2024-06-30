function drop_all_bags()
    local carry_data = managers.player:get_my_carry_data()

    for _, carry in pairs(carry_data) do
        managers.player:drop_carry()
    end
end

while managers.player:get_my_carry_data() do
    drop_all_bags()
end
