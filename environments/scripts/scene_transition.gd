extends Node
class_name SceneTransition

@export_file() var file:String
@export var exit_id:int = 0

# TODO Find solution that save position
func transition():
	SceneHandler.transition(file,exit_id)
