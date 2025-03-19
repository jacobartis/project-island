extends Node3D
class_name BarMinigame

@onready var player_bar_cam = $BarPlayer/PlayerBarCam
@onready var overview_cam = $OverviewCam

var player_cam_initial: Vector3

var selected = null

var held_glass = null

func is_player_view():
	return player_bar_cam.current

func _ready():
	player_cam_initial = player_bar_cam.global_position
	for x in get_tree().get_nodes_in_group("bm_item"):
		x.bar_minigame = self

static func _is_click(event:InputEventMouseButton,released=false):
	if !event: return false
	if event.button_index!=MOUSE_BUTTON_LEFT: return false
	return  (event.is_pressed() and not released) or (not event.is_pressed() and released)

func select_obj(obj):
	if not is_player_view(): return
	if selected:
		selected.unselect()
	selected = obj
	selected.select()
	var tween = get_tree().create_tween()
	tween.tween_property(player_bar_cam,"global_position",selected.cam_pos.global_position,.25)

func unselect_obj():
	var tween_back = get_tree().create_tween()
	tween_back.tween_property(player_bar_cam,"global_position",player_cam_initial,.25)
	selected.unselect()
	selected = null

func _on_select_player_input_event(camera, event, event_position, normal, shape_idx):
	if _is_click(event as InputEventMouseButton):
		overview_cam.current = false
		player_bar_cam.current = true

func _process(delta):
	if not Input.is_action_just_pressed("ui_cancel"): return
	if selected:
		unselect_obj()
	elif player_bar_cam.current:
		player_bar_cam.current = false
		overview_cam.current = true
	
