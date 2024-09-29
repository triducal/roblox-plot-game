local BroadcasterMiddleware = require(script.Middleware.BroadcasterMiddleware)
local Reflex = require("@Packages/Reflex")
local Sift = require("@Packages/Sift")
local Slices = require("@Shared/Store/Slices")

export type RootProducer = Reflex.Producer<RootState, RootActions>
export type RootState = Slices.SharedState & {}
export type RootActions = Slices.SharedActions & {}

local store: RootProducer = Reflex.combineProducers(Sift.Dictionary.merge(Slices), {})

store:applyMiddleware(BroadcasterMiddleware())

return store
