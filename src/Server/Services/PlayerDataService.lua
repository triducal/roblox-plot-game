local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ProfileService = require("@SPackages/ProfileService")

local Log = require("@Shared/Log")
local PlayerData = require("@Shared/Config/PlayerData")
local Selectors = require("@Shared/Store/Selectors")
local Store = require("@Server/Store")

local DATASTORE_KEY = RunService:IsStudio() and "DEV" or "PROD"

local ProfileStore = ProfileService.GetProfileStore(DATASTORE_KEY, PlayerData)
local Profiles = {}

local PlayerDataService = {}

local function SetupLeaderstats(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "💰 Coins"
	coins.Parent = leaderstats

	local gems = Instance.new("IntValue")
	gems.Name = "💎 Gems"
	gems.Parent = leaderstats

	local selector = Selectors.SelectPlayerBalance(tostring(player.UserId))
	local unsubscribe = Store:subscribe(selector, function(balance)
		coins.Value = balance.coins or 0
		gems.Value = balance.gems or 0
	end)

	Players.PlayerRemoving:Connect(function(leavingPlayer: Player)
		if leavingPlayer == player then
			unsubscribe()
		end
	end)
end

function CreateProfile(player: Player)
	local profile = ProfileStore:LoadProfileAsync(`Player_{player.UserId}`)
	if not profile then
		return
	end

	profile:ListenToRelease(function()
		Profiles[player.UserId] = nil
		Store.closePlayerData(tostring(player.UserId))
		player:Kick()
		return
	end)

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	Profiles[player.UserId] = profile
	Store.loadPlayerData(tostring(player.UserId), profile.Data)
	SetupLeaderstats(player)

	local selector = Selectors.SelectPlayerData(tostring(player.UserId))
	local unsubscribe = Store:subscribe(selector, function(playerData)
		if playerData then
			profile.Data = playerData
		end
	end)

	Log.info(`Data loaded for {player.Name}`)

	Players.PlayerRemoving:Connect(function(leavingPlayer: Player)
		if leavingPlayer == player then
			unsubscribe()
		end
	end)
end

function RemoveProfile(player: Player)
	local profile = Profiles[player.UserId]
	if not profile then
		return
	end

	profile:Release()
end

function PlayerDataService:Init()
	Players.PlayerAdded:Connect(CreateProfile)
	Players.PlayerRemoving:Connect(RemoveProfile)

	for _, player in ipairs(Players:GetPlayers()) do
		CreateProfile(player)
	end

	task.spawn(function()
		while true do
			for _, player in ipairs(Players:GetPlayers()) do
				Store.updateBalance(tostring(player.UserId), "coins", 1)
			end

			task.wait(1)
		end
	end)
end

return PlayerDataService
