local Reflex = require("@Packages/Reflex")

local Balance = require(script.Balance)
local PlayerData = require("@Shared/Config/PlayerData")

export type PlayerData = PlayerData.PlayerData
export type PlayerBalance = PlayerData.PlayerBalance

type PlayersProducer = Reflex.Producer<PlayersState, PlayersActions>

export type PlayersState = {
	balance: Balance.BalanceState,
}

export type PlayersActions = Balance.BalanceActions

local playersSlice: PlayersProducer = Reflex.combineProducers({
	balance = Balance,
})

return {
	playersSlice = playersSlice,
	template = PlayerData,
}
