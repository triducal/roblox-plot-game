return {
	Name = "TeleportPlot",
	Aliases = { "plot" },
	Description = "Teleport to a player's plot.",
	Group = "Admin",
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The owner of the plot you want to teleport to.",
		},
	},
}
