local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(script.Parent.Types)
local Items = ReplicatedStorage.Assets.items

local DecorationData: { [string]: Types.DecorationItem } = {
	["Cube"] = {
		asset = Items.Cube,
		price = 0,
	},
	["ExtraCube"] = {
		asset = Items.ExtraCube,
		price = 500,
	},
}

return DecorationData
