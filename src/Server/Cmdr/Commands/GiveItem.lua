return {
	Name = "GiveItem",
	Aliases = { "give" },
	Description = "Give a player any item from the game.",
	Group = "Admin",
	Args = {
		{
			Type = "item",
			Name = "Item",
			Description = "The item you want to give to the player.",
		},
		{
			Type = "player",
			Name = "Player",
			Description = "The player you want to give the item to.",
			Optional = true,
		},
	},
}
