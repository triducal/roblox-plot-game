local ItemData = require("@Shared/Config/ItemData")
local ItemTypes = require("@Shared/Config/ItemData/Types")
local Reflex = require("@Packages/Reflex")
local Sift = require("@Packages/Sift")

type Item = ItemTypes.Item

type PlotProducer = Reflex.Producer<PlotState, PlotActions>

export type PlotState = {
	placementEnabled: boolean,
	currentItem: Item,
}

export type PlotActions = {
	togglePlacement: () -> (),
	setCurrentItem: (item: Item) -> (),
}

local initialState: PlotState = {
	placementEnabled = false,
	currentItem = ItemData.Decoration["Cube"],
}

local plotSlice: PlotProducer = Reflex.createProducer(initialState, {
	togglePlacement = function(state)
		return Sift.Dictionary.set(state, "placementEnabled", not state.placementEnabled)
	end,

	setCurrentItem = function(state, item: Item)
		return Sift.Dictionary.set(state, "currentItem", item)
	end,
})

return plotSlice
