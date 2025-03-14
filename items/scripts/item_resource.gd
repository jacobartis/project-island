extends Resource
class_name Item
#Base resource for an item

@export var item_name: String = "Placeholder"
@export var description: String = "Placeholder Description"
@export var icon: Texture2D
@export var scene: PackedScene
@export var max_stack: int = 1

#On the fence
@export var additional_info_keys: Array[String] = []
