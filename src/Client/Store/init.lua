local ReceiverMiddleware = require(script.Middleware.ReceiverMiddleware)
local Reflex = require("@Packages/Reflex")
local Sift = require("@Packages/Sift")

local PlotSlice = require(script.Plot.PlotSlice)
local Slices = require("@Shared/Store/Slices")

export type RootProducer = Reflex.Producer<RootState, RootActions>
export type RootState = Slices.SharedState & {
	plot: PlotSlice.PlotState,
}
export type RootActions = Slices.SharedActions & PlotSlice.PlotActions

local store: RootProducer = Reflex.combineProducers(Sift.Dictionary.merge(Slices, {
	plot = PlotSlice,
}))

store:applyMiddleware(ReceiverMiddleware(), Reflex.loggerMiddleware)

return store
