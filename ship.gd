extends RigidBody2D


func _ready() -> void:
	mass = 1.
	gravity_scale = 0.
	add_to_group("ships")
	linear_velocity = Vector2(800, -500)
	angular_velocity = 100

func _process(delta: float) -> void:
	pass
