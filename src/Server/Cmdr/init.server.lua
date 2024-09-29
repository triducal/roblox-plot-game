local Cmdr = require("@SPackages/Cmdr")

local TypesFolder = script.Types
local CommandsFolder = script.Commands
local HooksFolder = script.Hooks

local function Register()
	Cmdr:RegisterDefaultCommands()
	Cmdr:RegisterTypesIn(TypesFolder)
	Cmdr:RegisterCommandsIn(CommandsFolder)
	Cmdr:RegisterHooksIn(HooksFolder)
end

Register()
