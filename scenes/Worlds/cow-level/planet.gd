extends Area2D


@export var mass = 1.
const creature_angles_deg = [0, 120]
@onready var radius = $CollisionShape2D.shape.radius

var creature = preload("res://scenes/Worlds/cow-level/creature.tscn")

func _ready() -> void:
	add_to_group("planets")
	print(radius)
	for angle in creature_angles_deg:
		var new_creature = creature.instantiate()
		new_creature.position = Vector2.RIGHT.rotated(deg_to_rad(angle)) * radius
		new_creature.add_to_group("creatures")
		add_child(new_creature)
	


func _process(delta: float) -> void:
	pass
