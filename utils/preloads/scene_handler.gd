extends Node

#Handles transitioning between scenes
var packed_player:PackedScene = null
var packed_player_2D:PackedScene = preload("res://player/scenes/player_2d.tscn")

func save_player():
	if get_tree().current_scene is Node2D: return
	var player = get_tree().get_first_node_in_group("player")
	packed_player = PackedScene.new()
	packed_player.pack(player)

#Helpful loading code from https://github.com/thelastflapjack/godot_open_star_fighter/tree/master
func transition(file:String,exit_id:int):
	save_player()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = null
	var err = ResourceLoader.load_threaded_request(file, "PackedScene")
	assert(err==OK,"Something bad happened")
	await get_tree().create_timer(.2).timeout
	await load_scene(file)
	var exits = get_tree().get_nodes_in_group("ExitPoint")
	var exit = null
	if not exits.filter(func (x): return x.id == exit_id).is_empty():
		exit = exits.filter(func (x): return x.id == exit_id)[0]
	if not exit:
		exit = exits[0]
	#TODO Temp to remove existing player from scenes
	if get_tree().get_first_node_in_group("player"):
		get_tree().get_first_node_in_group("player").queue_free()
	var player = packed_player.instantiate()
	if get_tree().current_scene is Node2D:
		player = packed_player_2D.instantiate()
	get_tree().current_scene.add_child(player)
	#Make transform if you want to have fun (applys exit scale to player)
	player.global_position = exit.global_position

func load_scene(file):
	var load_progress:Array[float] = []
	var load_status: int = ResourceLoader.load_threaded_get_status(file,load_progress)
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed: PackedScene = ResourceLoader.load_threaded_get(file)
		var scene = packed.instantiate()
		get_tree().get_root().add_child(scene)
		get_tree().current_scene = scene
		return
	elif load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().create_timer(.2).timeout
		load_scene(file)
	else:
		@warning_ignore("assert_always_false")
		assert(false,"ResourceLoad Error: "+str(load_status))
