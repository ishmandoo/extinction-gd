extends RigidBody2D

const EXPLOSION_RADIUS = 250.
var alive = true
var dragging = false
var setup = true


func _ready() -> void:
	mass = 1.
	linear_damp_mode = DAMP_MODE_REPLACE
	gravity_scale = 0.
	freeze = true
	
	add_to_group("ships")
	linear_velocity = Vector2(100, 1000)
	angular_velocity = 100
	
	input_pickable = true
	
	connect("mouse_entered", _mouse_entered)
	connect("mouse_exited", _mouse_exited)

func _mouse_entered():
	print("entered")
	dragging = true
	
func _mouse_exited():
	print("exited")
	if not Input.is_action_pressed("mouse_left"):
		dragging = false

func _process(delta: float) -> void:
	if setup and dragging:
		if Input.is_action_pressed("mouse_left"):
			global_position = get_global_mouse_position()
	

func run():
	freeze = false
	setup = false
	
func crash():
	print("ship crashing")
	alive = false
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	freeze = true
