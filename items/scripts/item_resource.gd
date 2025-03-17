extends Resource
class_name Item
#Base resource for an item

@export var item_name: String = "Placeholder"
@export_multiline var description: String = "Placeholder Description"
@export var icon: Texture2D
@export var scene: PackedScene
@export var max_stack: int = 1

@export var additional_info: Dictionary[String,AdditionalItemData] = {}
@export var tags: Array[String] = []
