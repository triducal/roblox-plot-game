local Reflex = require("@Packages/Reflex")

local PlayersSlice = require("@Shared/Store/Slices/Players")
local Slices = require("@Shared/Store/Slices")

local function SelectPlayerBalance(playerId: string)
	return function(state: Slices.SharedState)
		return state.players.balance[playerId]
	end
end

local function SelectPlayerData(playerId: string)
	return Reflex.createSelector(
		SelectPlayerBalance(playerId),
		function(balance: PlayersSlice.PlayerBalance?): PlayersSlice.PlayerData?
			if not balance then
				return
			end

			return {
				balance = balance,
			}
		end
	)
end

return {
	SelectPlayerBalance = SelectPlayerBalance,
	SelectPlayerData = SelectPlayerData,
}
