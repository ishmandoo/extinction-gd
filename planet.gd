extends Area2D

@export var mass = 1

func _ready() -> void:
	add_to_group("planets")
	


func _process(delta: float) -> void:
	pass
