extends BarMinigameItem

@export var speed:float = .04
@onready var tap = $Tap

@export var pull_limit:float = 60
var up_limit:float = 0
var min_pour_angle: float = 20
var held: bool = false
var glass = null

func pouring_rate():
	return max((tap.rotation_degrees.x-min_pour_angle)/(pull_limit-min_pour_angle),0)

func _input(event):
	if bar_minigame.selected != self: return
	if BarMinigame._is_click(event as InputEventMouseButton,true):
		held = false
	if held:
		handle_motion(event as InputEventMouseMotion)

func _process(delta):
	if bar_minigame.selected != self: return
	if pouring_rate()==0: return
	if not glass: return
	glass.add_liquid(pouring_rate())

func place_glass():
	if !bar_minigame.held_glass: return
	glass = bar_minigame.held_glass
	bar_minigame.held_glass = null
	$GlassPlace.add_child(glass)
	glass.global_position = $GlassPlace.global_position

func take_glass():
	if bar_minigame.held_glass: return
	bar_minigame.held_glass = glass
	$GlassPlace.remove_child(glass)
	glass = null

func handle_motion(event:InputEventMouseMotion):
	if !event: return
	tap.rotate(Vector3.RIGHT,event.relative.y*speed)
	tap.rotation_degrees.x = clampf(tap.rotation_degrees.x,up_limit,pull_limit)

func _on_select_area_input_event(camera, event, event_position, normal, shape_idx):
	if BarMinigame._is_click(event as InputEventMouseButton):
		bar_minigame.select_obj(self)

func _on_pull_input_event(camera, event, event_position, normal, shape_idx):
	if BarMinigame._is_click(event as InputEventMouseButton):
		held = true

func _on_glass_place_input_event(camera, event, event_position, normal, shape_idx):
	if not BarMinigame._is_click(event as InputEventMouseButton):return
	if not glass:
		place_glass()
	else:
		take_glass()
	
