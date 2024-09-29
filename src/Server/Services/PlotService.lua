local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local Log = require("@Shared/Log")
local Remotes = require("@Shared/Remotes")

export type Plot = {
	owner: string?,
	instance: Part,
	objects: { Model },
}

local PLOT_TAG = "Plot"

local Plots: { Plot } = {}

local PlotService = {}

function PlotService:Init()
	local plots = CollectionService:GetTagged(PLOT_TAG)

	for _, plot in plots do
		table.insert(Plots, {
			owner = nil,
			instance = plot,
			objects = {},
		})
	end

	Remotes.requestPlot:onRequest(function(player)
		local plot = PlotService:ClaimPlot(player)
		PlotService:TeleportToPlot(player, player)

		return plot.instance
	end)

	Players.PlayerRemoving:Connect(function(player)
		PlotService:UnclaimPlot(player)
	end)
end

function PlotService:ClaimPlot(player: Player): Plot
	for _, plot in Plots do
		if plot.owner == nil then
			plot.owner = player.Name
			return plot
		end
	end

	player:Kick("No plots available")
end

function PlotService:FindPlot(player: Player): Plot?
	for _, plot in Plots do
		if plot.owner == player.Name then
			return plot
		end
	end

	return nil
end

function PlotService:UnclaimPlot(player: Player)
	local plot = PlotService:FindPlot(player)

	if plot then
		plot.owner = nil
	end
end

function PlotService:TeleportToPlot(playerToTeleport: Player, player: Player)
	local plot = PlotService:FindPlot(player)
	local character = playerToTeleport.Character or playerToTeleport.CharacterAdded:Wait()

	if plot and character then
		local plotInstance = plot.instance :: Part
		character:PivotTo(plotInstance.CFrame + Vector3.new(0, plotInstance.Size.Y / 2, 0))
	else
		Log.warn("Unable to teleport to plot. Plot or character not found.")
	end
end

return PlotService
