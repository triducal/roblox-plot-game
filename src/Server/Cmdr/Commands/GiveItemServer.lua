local ItemData = require("@Shared/Config/ItemData")
local Log = require("@Shared/Log")

return function(context, item: string, player: Player?)
	player = player and player or context.Executor

	if player then
		Log.info(player, item)
	end
end
