extends Node

signal start_dialogue()
signal end_dialogue()

var in_dialogue: bool = false

#Bad but single player so we good
func get_player():
	return get_tree().get_first_node_in_group("player")

func _ready():
	DialogueManager.dialogue_started.connect(d_start)
	DialogueManager.dialogue_ended.connect(d_end)

func d_start(_d):
	in_dialogue = true
	start_dialogue.emit()
func d_end(_d):
	in_dialogue = false
	end_dialogue.emit()

func give_item(n):
	var item = null
	match n:
		"rod":
			item = preload("res://player/items/fishing_rod/fishing_rod.tscn").instantiate()
		_:
			push_warning("No such item "+n)
			return
	get_player().give_item(item)

func give_hat(n):
	var hat = null
	match n:
		"fishing":
			hat = preload("res://player/hats/fishing_hat.tscn").instantiate()
		_:
			push_warning("No such hat "+n)
			return
	get_player().give_hat(hat)

#THIS WILL BE UGLY.
#Used by dialogue manager to access the state.
var test_state:String = ""
var fish:String = ""
var rod:String = ""
