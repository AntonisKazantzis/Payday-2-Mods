local original_function = original_function or ChallengeManager.activate_challenge

function ChallengeManager:activate_challenge(id, key, category)
    if self:has_active_challenges(id, key) then
        local challenge = self:get_challenge(id, key)

        challenge.completed = true
        challenge.rewarded = true
        challenge.category = category

        self._global.active_challenges[key or Idstring(id):key()] = challenge

        return true
    end

    return original_function(self, id, key, category)
end
