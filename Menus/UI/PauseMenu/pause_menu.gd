extends Control

func _process(delta):
	if not Input.is_action_just_pressed("ui_cancel"): return
	if SceneHandler.scene_name == "MainMenu": return
	if State.in_menu: return
	if $Options.visible:
		$Options.hide()
		return
	if get_tree().paused:
		resume()
	else:
		pause()

func pause():
	Mouse.unlock()
	State.pause()
	show()

func resume():
	Mouse.lock()
	State.unpause()
	hide()

#TODO Add save warning
func _on_quit_menu_pressed():
	resume()
	Mouse.unlock()
	SceneHandler.transition("MainMenu",0)

func _on_quit_desktop_pressed():
	get_tree().quit()
