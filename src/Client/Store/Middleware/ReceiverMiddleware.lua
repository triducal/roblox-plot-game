local Reflex = require("@Packages/Reflex")
local Remotes = require("@Shared/Remotes")

local function receiverMiddleware()
	local receiver = Reflex.createBroadcastReceiver({
		start = function()
			Remotes.Reflex.start()
			return
		end,
	})

	Remotes.Reflex.broadcast:connect(function(actions)
		receiver:dispatch(actions)
	end)

	return receiver.middleware
end

return receiverMiddleware
