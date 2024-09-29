--!nonstrict

local ItemData = require("@Shared/Config/ItemData")

local items = {}

for _, itemType in ItemData do
	for key, _ in itemType do
		table.insert(items, key)
	end
end

return function(registry)
	registry:RegisterType("item", registry.Cmdr.Util.MakeEnumType("item", items))
end
