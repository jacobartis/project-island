extends Node
#THIS WILL BE UGLY.
#Used by dialogue manager to access the state.

signal start_dialogue()
signal end_dialogue()

var in_dialogue: bool = false

func _ready():
	DialogueManager.dialogue_started.connect(d_start)
	DialogueManager.dialogue_ended.connect(d_end)

func d_start(_d):
	in_dialogue = true
	start_dialogue.emit()
func d_end(_d):
	in_dialogue = false
	end_dialogue.emit()



var test_state:String = "true"
