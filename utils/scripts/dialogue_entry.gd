extends Node

@export var dialogue_resource:DialogueResource
@export var dialogue_start:String = "start"

func start_dialogue():
	DialogueManager.show_dialogue_balloon(dialogue_resource,dialogue_start)
