--[[
    @class PlotController
    @description Handles the placement of items on the plot and communication with server
--]]

--> Services <--
local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--> Modules <--
local ItemTypes = require("@Shared/Config/ItemData/Types")
local Log = require("@Shared/Log")
local Remotes = require("@Shared/Remotes")
local Store = require("@Client/Store")

--> Types <--
type Item = ItemTypes.Item

--> Selectors <--
local PlotSelectors = require("@Client/Store/Plot/PlotSelectors")

--> Constants <--
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--> Variables <--
local Plot: Part = nil
local PlacementEnabled: boolean = false
local CurrentModel: Model = nil

--> Functions <--
local function handleItemCloning(item: Item)
	-- If a past model existed, move to it for smooth transition, if not, go to the mouse position
	local currentCFrame = CurrentModel.PrimaryPart and CurrentModel.PrimaryPart.CFrame or CFrame.new(Mouse.Hit.Position)

	local model = item.asset:Clone()

	-- If the model does not have a primary part, keep the current model
	if not model.PrimaryPart then
		model:Destroy()
		return
	end

	model.Parent = workspace
	model.Name = "HoverItem"
	model.PrimaryPart.CFrame = currentCFrame

	CurrentModel = model
end

local function handleToggledPlacement(state: boolean)
	PlacementEnabled = state
	CurrentModel.Parent = PlacementEnabled and workspace or nil
end

local function handlePlacementRendering()
	if not PlacementEnabled or not Plot or not CurrentModel then
		return
	end
end

local function handleActions(actionName: string, inputState: Enum.UserInputState)
	if inputState ~= Enum.UserInputState.Begin then
		return
	end

	if actionName == "Toggle" then
		Store.togglePlacement()
	end
end

--> Controller <--
local PlotController = {}

function PlotController:Init()
	--Initialize model with default item state
	handleItemCloning(Store:getState().plot.currentItem)

	-- Request initial plot from server
	Remotes.requestPlot:request():andThen(function(plot)
		Plot = plot
		Log.info("Received plot from server")
	end)

	-- Listen for state changes
	Store:subscribe(PlotSelectors.SelectPlacementToggled(), handleToggledPlacement)
	Store:subscribe(PlotSelectors.SelectCurrentItem(), handleItemCloning)

	-- Bind actions/keybinds
	ContextActionService:BindAction("Toggle", handleActions, false, Enum.KeyCode.E)

	-- Bind rendering for placement
	RunService:BindToRenderStep("Placement", 1, handlePlacementRendering)
end

return PlotController
