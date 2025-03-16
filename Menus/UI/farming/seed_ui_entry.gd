extends Control

@export var name_label:Label
@export var description_label:Label

var seed_id:int

func set_seed(id:int):
	seed_id = id
	update()

func update():
	var data = SeedPouch.crops[seed_id]
	name_label.set_text(data.plant_name)
	description_label.set_text(data.description)
