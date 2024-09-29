local Reflex = require("@Packages/Reflex")
local Sift = require("@Packages/Sift")

local PlayerData = require("@Shared/Config/PlayerData")

type BalanceProducer = Reflex.Producer<BalanceState, BalanceActions>

export type BalanceState = {
	[string]: PlayerData.PlayerBalance,
}

export type BalanceActions = {
	loadPlayerData: (playerId: string, data: PlayerData.PlayerData) -> (),
	closePlayerData: (playerId: string) -> (),
	updateBalance: (playerId: string, currency: PlayerData.Currency, amount: number) -> (),
	setBalance: (playerId: string, currency: PlayerData.Currency, amount: number) -> (),
}

local initialState: BalanceState = {}

local balanceSlice: BalanceProducer = Reflex.createProducer(initialState, {
	loadPlayerData = function(state, playerId: string, data: PlayerData.PlayerData)
		return Sift.Dictionary.set(state, playerId, data.balance)
	end,

	closePlayerData = function(state, playerId: string)
		return Sift.Dictionary.removeKey(state, playerId)
	end,

	updateBalance = function(state, playerId: string, currency: PlayerData.Currency, amount: number)
		return Sift.Dictionary.update(state, playerId, function(balance: PlayerData.PlayerBalance)
			return Sift.Dictionary.set(balance, currency, balance[currency] + amount)
		end)
	end,

	setBalance = function(state, playerId: string, currency: PlayerData.Currency, amount: number)
		return Sift.Dictionary.update(state, playerId, function(balance: PlayerData.PlayerBalance)
			return Sift.Dictionary.set(balance, currency, amount)
		end)
	end,
})

return balanceSlice
