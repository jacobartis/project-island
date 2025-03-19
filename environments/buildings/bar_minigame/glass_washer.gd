extends BarMinigameItem

@onready var animation_player = $Machine/AnimationPlayer
@onready var glasses = $Machine/GlassDraw/Glasses
@onready var glass_spawns = $Machine/GlassDraw/GlassSpawns

var washing: bool = false
var open:bool = false

func add_glass():
	var glass = bar_minigame.held_glass
	bar_minigame.held_glass = null
	glasses.add_child(glass)
	glass.global_position = glass_spawns.get_children().pick_random().global_position
	glass.clicked.connect(_on_glass_clicked.bind(glass))

func pickup_glass(glass):
	glasses.remove_child(glass)
	bar_minigame.held_glass = glass
	glass.clicked.disconnect(_on_glass_clicked)

func start_wash():
	$WashTime.start()
	animation_player.play("close")
	open = false
	washing = true

func finish_wash():
	washing = false
	for glass in glasses.get_children():
		glass.dirty = false
	animation_player.play("open")
	open = true

func _on_animation_player_animation_finished(anim_name):
	if not washing: return
	animation_player.play("active")

func _on_wash_time_timeout():
	finish_wash()

func _on_unselected():
	if washing: return
	if not open: return
	animation_player.stop()
	animation_player.play("soft_close")
	open = false

func _on_selected():
	if washing and not open: return
	animation_player.stop()
	animation_player.play("soft_open")
	open = true

func _on_select_area_input_event(camera, event, event_position, normal, shape_idx):
	if not bar_minigame.is_player_view(): return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	bar_minigame.select_obj(self)

func _on_glass_clicked(glass):
	if not bar_minigame.selected == self: return
	if bar_minigame.held_glass: return
	pickup_glass(glass)

func _on_place_glass_area_input_event(camera, event, event_position, normal, shape_idx):
	if not bar_minigame.selected == self: return
	if not bar_minigame.held_glass: return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	add_glass()


func _on_start_button_input_event(camera, event, event_position, normal, shape_idx):
	if not bar_minigame.selected == self: return
	if washing: return
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	start_wash()
