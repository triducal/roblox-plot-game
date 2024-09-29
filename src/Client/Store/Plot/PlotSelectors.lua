local ItemTypes = require("@Shared/Config/ItemData/Types")
local Root = require(script.Parent.Parent)
local Sift = require("@Packages/Sift")

type Item = ItemTypes.Item

local function SelectPlacementToggled()
	return function(state: Root.RootState): boolean
		return state.plot.placementEnabled
	end
end

local function SelectCurrentItem()
	return function(state: Root.RootState): Item
		return state.plot.currentItem
	end
end

local Selectors = {
	SelectPlacementToggled = SelectPlacementToggled,
	SelectCurrentItem = SelectCurrentItem,
}

return Sift.Dictionary.merge(Selectors) :: typeof(Selectors)
