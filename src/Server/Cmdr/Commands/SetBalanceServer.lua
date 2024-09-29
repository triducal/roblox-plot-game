local PlayerData = require("@Shared/Config/PlayerData")
local Store = require("@Server/Store")

return function(context, currency: PlayerData.Currency, amount: number, player: Player?)
	player = player and player or context.Executor

	if player then
		Store.setBalance(tostring(player.UserId), currency, amount)
	end
end
