extends BarMinigameItem

signal glass_served()

func _on_select_area_input_event(camera, event, event_position, normal, shape_idx):
	if not bar_minigame.is_player_view(): return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	bar_minigame.select_obj(self)

func serve_glass():
	var glass = bar_minigame.held_glass
	bar_minigame.held_glass = null
	add_child(glass)
	#TEMP!!!!
	await get_tree().create_timer(1).timeout
	glass.queue_free()
	glass_served.emit()
	print(glass.get_score())


func _on_place_select_area_input_event(camera, event, event_position, normal, shape_idx):
	if bar_minigame.selected != self: return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	serve_glass()
