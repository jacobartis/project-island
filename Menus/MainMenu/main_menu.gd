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

func _on_music_slider_value_changed(value):
	Options.music_volume = value/100.0


func _on_master_slider_value_changed(value):
	Options.master_volume = value/100.0


func _on_sfx_slider_value_changed(value):
	Options.sfx_volume = value/100.0

func _on_sensitivity_slider_value_changed(value):
	Options.sensitivity = Options.MAX_SENSITIVITY*(value/100)

func _input(event):
	if not $AnimationPlayer.is_playing() or $AnimationPlayer.current_animation != "intro": return
	var button = event as InputEventKey
	var click = event as InputEventMouseButton
	if not button and not click: return
	$AnimationPlayer.play("skip")
