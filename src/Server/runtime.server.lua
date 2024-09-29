local Loader = require("@Packages/Loader")

local Services = script.Parent.Services
Loader.SpawnAll(Loader.LoadDescendants(Services, Loader.MatchesName("Service$")), "Init")
