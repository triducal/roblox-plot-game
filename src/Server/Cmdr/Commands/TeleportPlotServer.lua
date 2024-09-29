local PlotService = require("@Services/PlotService")

return function(context, player: Player)
	PlotService:TeleportToPlot(player, context.Executor)
end
