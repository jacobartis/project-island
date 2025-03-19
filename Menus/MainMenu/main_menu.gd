extends Control

func _on_start_pressed():
	SceneHandler.transition("Cove",-1)


func scene_menu_update():
	for x in %SceneButtonHolder.get_children():
		x.queue_free()
	for scene in SceneHandler.default_scenes:
		var button = Button.new()
		button.size_flags_horizontal = 3
		button.text = scene
		button.pressed.connect(scene_button_pressed.bind(scene))
		%SceneButtonHolder.add_child(button)

func _on_load_scene_pressed():
	$Buttons.hide()
	scene_menu_update()
	$SceneLoader.show()


func _on_scene_loader_close_pressed():
	$Buttons.show()
	$SceneLoader.hide()

func scene_button_pressed(scene):
	SceneHandler.transition(scene,%ExitId.value)


func _on_quit_pressed():
	get_tree().quit()
