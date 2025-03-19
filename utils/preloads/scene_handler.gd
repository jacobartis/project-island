extends Node

#Handles transitioning between scenes
var packed_player:PackedScene = preload("res://player/scenes/player.tscn")
var packed_player_2D:PackedScene = preload("res://player/scenes/player_2d.tscn")

var scene_name: String = ""

var default_scenes: Dictionary = {
	"Cove":preload("res://environments/beach/beach.tscn"),
	"Alley":preload("res://environments/buildings/alley/alley.tscn"),
	"Bar":preload("res://environments/buildings/bar/bar.tscn"),
	"FishingHut":preload("res://environments/buildings/fishing_hut/fishing_hut.tscn"),
	"2d":preload("res://environments/2d/2d_test.tscn"),
	"House":preload("res://environments/buildings/house/player_house.tscn"),
	"BarMinigame":preload("res://environments/buildings/bar_minigame/bar_minigame.tscn"),
}

var scenes: Dictionary = {}

func save_scenes():
	for scene_id in scenes.keys():
		ResourceSaver.save(scenes[scene_id],"res://saves/{id}.tscn".format({"id":scene_id}))

func load_scenes():
	for scene_id in default_scenes.keys():
		var path = "res://saves/{id}.tscn".format({"id":scene_id})
		await  load_scene_file(path)
		if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			continue
		var packed = ResourceLoader.load_threaded_get(path)
		if packed:
			scenes[scene_id] = packed

func load_scene_file(file):
	var load_progress:Array[float] = []
	var load_status: int = ResourceLoader.load_threaded_get_status(file,load_progress)
	if load_status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		return
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed: PackedScene = ResourceLoader.load_threaded_get(file)
		return 
	elif load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().create_timer(.2).timeout
		load_scene(file)
	else:
		@warning_ignore("assert_always_false")
		assert(false,"ResourceLoad Error: "+str(load_status))

func store_scene():
	var scene = PackedScene.new()
	scene.pack(get_tree().current_scene)
	scenes[scene_name] = scene

func get_scene(n:String):
	if n in scenes:
		return scenes[n]
	elif n in default_scenes:
		return default_scenes[n]
	else:
		push_error("No such scene {s}".format({"s":n}))

func store_player():
	if get_tree().current_scene is Node2D: return
	if not get_tree().get_first_node_in_group("player"): return
	var player = get_tree().get_first_node_in_group("player")
	packed_player = PackedScene.new()
	packed_player.pack(player)

#Helpful loading code from https://github.com/thelastflapjack/godot_open_star_fighter/tree/master
func transition(scene_name:String,exit_id:int,add_player:bool=true):
	store_player()
	store_scene()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = null
	#Not sure if need in new system
	#var err = ResourceLoader.load_threaded_request(file, "PackedScene")
	#assert(err==OK,"Something bad happened")
	await get_tree().create_timer(.2).timeout
	await load_scene(scene_name)
	
	if not add_player: return
	 
	var exits = get_tree().get_nodes_in_group("ExitPoint")
	var exit = null
	if exits.is_empty():
		return
	if not exits.filter(func (x): return x.id == exit_id).is_empty():
		exit = exits.filter(func (x): return x.id == exit_id)[0]
	if not exit:
		exit = exits[0]
	#TODO Temp to remove existing player from scenes
	if get_tree().get_first_node_in_group("player"):
		get_tree().get_first_node_in_group("player").queue_free()
	var player = packed_player.instantiate()
	print(packed_player.can_instantiate())
	print(packed_player)
	if get_tree().current_scene is Node2D:
		player = packed_player_2D.instantiate()
	get_tree().current_scene.add_child(player)
	#Make transform if you want to have fun (applys exit scale to player)
	player.global_position = exit.global_position
	exit.used.emit()


func load_scene(new_scene_name:String):
	var scene_packed: PackedScene = get_scene(new_scene_name)
	var scene = scene_packed.instantiate()
	get_tree().get_root().add_child(scene)
	get_tree().current_scene = scene
	scene_name = new_scene_name
	return
