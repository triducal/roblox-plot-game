local Reflex = require("@Packages/Reflex")
local Remo = require("@Packages/Remo")
local t = require("@Packages/t")

type Remotes = {
	Reflex: {
		broadcast: Remo.ServerToClient<{ Reflex.BroadcastAction }>,
		start: Remo.ClientToServer<nil>,
	},
	requestPlot: Remo.ClientToServerAsync<(), (Part)>,
}

local remotes: Remotes = Remo.createRemotes({
	Reflex = Remo.namespace({
		broadcast = Remo.remote(t.table),
		start = Remo.remote(),
	}),
	requestPlot = Remo.remote().returns(t.Instance),
})

return remotes
