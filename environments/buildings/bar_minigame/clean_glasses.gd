extends BarMinigameItem

@export var starting_glasses:int = 5
const GLASS = preload("res://environments/buildings/bar_minigame/glass.tscn")

func _ready():
	for x in starting_glasses:
		var glass = GLASS.instantiate()
		$Glasses.add_child(glass)
		glass.global_position = $GlassSpawns.get_children().pick_random().global_position
		glass.clicked.connect(_on_glass_clicked.bind(glass))


func _on_select_area_input_event(camera, event, event_position, normal, shape_idx):
	if not bar_minigame.is_player_view(): return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	bar_minigame.select_obj(self)

#TODO Create clean glass scene that stacks glasses if already in position.
func add_glass():
	if not bar_minigame.held_glass: return
	var glass = bar_minigame.held_glass
	bar_minigame.held_glass = null
	$Glasses.add_child(glass)
	glass.global_position = $GlassSpawns.get_children().pick_random().global_position
	glass.clicked.connect(_on_glass_clicked.bind(glass))

func pickup_glass(glass):
	$Glasses.remove_child(glass)
	bar_minigame.held_glass = glass
	glass.clicked.disconnect(_on_glass_clicked)

func _on_glass_clicked(glass):
	if not bar_minigame.selected == self: return
	if bar_minigame.held_glass: return
	pickup_glass(glass)


func _on_place_glass_area_input_event(camera, event, event_position, normal, shape_idx):
	if not bar_minigame.is_player_view(): return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	add_glass()
