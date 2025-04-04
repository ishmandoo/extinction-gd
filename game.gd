extends Control

@onready var space = $Space
@onready var pause_menu = $PauseMenu
@onready var spotlight = $Spotlight
@onready var infopanel = $InfoPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_input()
	spotlight_follow_mouse()
	
	
func process_input():
	if Input.is_action_just_pressed("edit_velocities"):
		infopanel.modulate = Color(1,1,1,0.5)
		pause_menu.show()
		self.set_spotlight(1, 0.2)
		space.get_tree().paused = true
	if Input.is_action_just_released("edit_velocities"):
		infopanel.modulate = Color(1,1,1,1)
		pause_menu.hide()
		self.set_spotlight(0.2, 0.2)
		space.get_tree().paused = false

func set_spotlight(target_energy, time = 0):
	print('set spotlight!')
	if time == 0:
		spotlight.energy = target_energy
	else:
		var dimmer = get_tree().create_tween()
		dimmer.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
		dimmer.tween_property(spotlight, "energy", target_energy, time)

func spotlight_follow_mouse():
	spotlight.position = get_viewport().get_mouse_position()

func toggle_spotlight():
	spotlight.enabled = not spotlight.enabled
