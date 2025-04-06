extends Control

@onready var space = $Space
@onready var pause_menu = $PauseMenu
@onready var spotlight = $Spotlight
@onready var infopanel = $InfoPanel
@onready var window_size = get_window().size

# group management
# does Game need to track these or is it just repeating what the scenetree does anyway?
var gravity_bodies = []
var massive_bodies = []
var reactive_bodies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#space.create_oreo(window_size/3, Vector2(-35,20))
	#space.create_oreo_grid(6, 12, Vector2(0, -30))
	collect_groups()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spotlight_follow_mouse()
	process_input()
	
	
func process_input():
	if Input.is_action_just_pressed("edit_velocities"):
		infopanel.modulate = Color(1,1,1,0.5)
		pause_menu.show()
		self.set_spotlight(1, 0.1)
		show_labels()
		space.get_tree().paused = true
	if Input.is_action_just_released("edit_velocities"):
		infopanel.modulate = Color(1,1,1,1)
		pause_menu.hide()
		self.set_spotlight(0.2, 0.2)
		hide_labels()
		space.get_tree().paused = false
	if Input.is_action_just_pressed("escape"):
		switch_scene("res://scenes/Title.tscn")

################
#### groups ####
################

func collect_groups():
	gravity_bodies = get_tree().get_nodes_in_group("gravity_bodies")
	massive_bodies = get_tree().get_nodes_in_group("massive_bodies")
	reactive_bodies = get_tree().get_nodes_in_group("reactive_bodies")

#################
#### pausing ####
#################

func hide_labels(group_name = "gravity_bodies"):
	get_tree().call_group(group_name, "hide_guide")
		
func show_labels(group_name = "gravity_bodies"):
	get_tree().call_group(group_name, "show_guide")

###############
### lights ####
###############

func set_spotlight(target_energy, time = 0):
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

func switch_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)	
