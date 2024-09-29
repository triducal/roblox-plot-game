type BaseItem = {
	asset: Model,
	price: number,
}

export type DecorationItem = BaseItem & {}
export type ConveyorItem = BaseItem & {}
export type DropperItem = BaseItem & {}

export type Item = DecorationItem | ConveyorItem | DropperItem

return "Types"
