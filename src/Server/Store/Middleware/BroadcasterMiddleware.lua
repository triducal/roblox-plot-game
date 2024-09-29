local Reflex = require("@Packages/Reflex")
local Remotes = require("@Shared/Remotes")
local Slices = require("@Shared/Store/Slices")

local function broadcasterMiddleware()
	local broadcaster = Reflex.createBroadcaster({
		producers = Slices,
		dispatch = function(player, actions)
			Remotes.Reflex.broadcast(player, actions)
		end,
	})

	Remotes.Reflex.start:connect(function(player)
		return broadcaster:start(player)
	end)

	return broadcaster.middleware
end

return broadcasterMiddleware
