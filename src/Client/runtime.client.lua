local Loader = require("@Packages/Loader")

local Controllers = script.Parent.Controllers
Loader.SpawnAll(Loader.LoadDescendants(Controllers, Loader.MatchesName("Controller$")), "Init")
