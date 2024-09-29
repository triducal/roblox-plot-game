local PlacementUtil = {}

function PlacementUtil:CalculatePlot(plot: Part): (CFrame, Vector2)
	local plotSize = plot.Size

	-- want to create CFrame such that cf.lookVector == plot.CFrame.upVector
	-- do this by using object space and build the CFrame
	local back = Vector3.new(0, -1, 0)
	local top = Vector3.new(0, 0, -1)
	local right = Vector3.new(-1, 0, 0)

	-- convert to world space
	local cf = plot.CFrame * CFrame.fromMatrix(-back * plotSize / 2, right, top, back)
	-- use object space vectors to find the width and height
	local size = Vector2.new((plotSize * right).Magnitude, (plotSize * top).Magnitude)

	return cf, size
end

function PlacementUtil:CalculatePlacement(
	plot: Part,
	item: Model,
	position: Vector3,
	rotation: number,
	gridUnit: number
): CFrame?
	local cf, size = PlacementUtil:CalculatePlot(plot)

	-- if the item does not have a primary part, we cannot move it properly
	if not item.PrimaryPart then
		return nil
	end

	-- rotate the size so that we can properly constrain to the surface
	local modelSize = CFrame.fromEulerAnglesYXZ(0, rotation, 0) * item.PrimaryPart.Size
	modelSize = Vector3.new(math.abs(modelSize.X), math.abs(modelSize.Y), math.abs(modelSize.Z))

	-- get the position relative to the surface's CFrame
	local lpos = cf:PointToObjectSpace(position)
	-- the max bounds the model can be from the surface's center
	local size2 = (size - Vector2.new(modelSize.X, modelSize.Z)) / 2

	-- constrain the position using size2
	local x = math.clamp(lpos.X, -size2.X, size2.X)
	local y = math.clamp(lpos.Y, -size2.Y, size2.Y)

	-- snap to grid
	if gridUnit > 0 then
		x = math.sign(x) * ((math.abs(x) - math.abs(x) % gridUnit) + (size2.X % gridUnit))
		y = math.sign(y) * ((math.abs(y) - math.abs(y) % gridUnit) + (size2.Y % gridUnit))
	end

	-- create and return the CFrame
	return cf * CFrame.new(x, y, -modelSize.Y / 2) * CFrame.Angles(-math.pi / 2, rotation, 0)
end

return PlacementUtil
