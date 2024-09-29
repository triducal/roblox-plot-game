return {
	Name = "SetBalance",
	Aliases = { "sb" },
	Description = "Set's a player's balance.",
	Group = "Admin",
	Args = {
		{
			Type = "currency",
			Name = "Currency",
			Description = "",
		},
		{
			Type = "number",
			Name = "Amount of currency",
			Description = "The amount of currency to set to the player.",
		},
		{
			Type = "player",
			Name = "Player",
			Description = "The Player",
			Optional = true,
		},
	},
}
