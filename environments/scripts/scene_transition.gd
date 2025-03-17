extends Node
class_name SceneTransition

@export var scene_name:String
@export var exit_id:int = 0

# TODO Find solution that save position
func transition():
	SceneHandler.transition(scene_name,exit_id)
