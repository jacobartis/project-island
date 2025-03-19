extends BarMinigameItem

const GLASS = preload("res://environments/buildings/bar_minigame/glass.tscn")

var dirty_glasses: int = 0

func add_glass():
	dirty_glasses += 1
	var glass = GLASS.instantiate()
	$Glasses.add_child(glass)
	glass.dirty = true
	glass.global_position = $GlassSpawns.get_children().pick_random().global_position
	glass.clicked.connect(_on_glass_clicked.bind(glass))

func pickup_glass(glass):
	if dirty_glasses<=0: return
	$Glasses.remove_child(glass)
	bar_minigame.held_glass = glass
	dirty_glasses -= 1

func _on_select_area_input_event(camera, event, event_position, normal, shape_idx):
	if not bar_minigame.is_player_view(): return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	bar_minigame.select_obj(self)

func _on_glass_clicked(glass):
	if not bar_minigame.selected == self: return
	if bar_minigame.held_glass: return
	if dirty_glasses <= 0: return
	pickup_glass(glass)
