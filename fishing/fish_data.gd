extends Resource
class_name FishData

@export var item_id: String
@export_range(0,10,.5) var difficulty:float
@export_enum("Common","Uncommon","Rare","Epic","Legendary","Mythic") var rarity = 0
