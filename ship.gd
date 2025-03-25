extends RigidBody2D

const EXPLOSION_RADIUS = 250.
var alive = true

func _ready() -> void:
	mass = 1.
	linear_damp_mode = DAMP_MODE_REPLACE
	gravity_scale = 0.
	
	add_to_group("ships")
	linear_velocity = Vector2(800, -500)
	angular_velocity = 100
	

func _process(delta: float) -> void:
	pass
	
func crash():
	print("ship crashing")
	alive = false
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	freeze = true
