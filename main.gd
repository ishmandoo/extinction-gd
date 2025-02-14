extends Node2D

var planets
var ships

const G = 1e9

func _ready() -> void:
	planets = get_tree().get_nodes_in_group("planets")
	ships = get_tree().get_nodes_in_group("ships")
	

func gravity_force(ship, planet) -> Vector2:
	var direction = planet.global_position - ship.global_position 
	var distance_sq = direction.length_squared()
	if distance_sq == 0:
		return Vector2.ZERO
	var force_magnitude = G * (ship.mass * planet.mass) / distance_sq
	var force_vector = direction.normalized() * force_magnitude
	return force_vector
	
func _process(delta: float) -> void:
	pass
			
func _physics_process(delta: float) -> void:
	for ship in ships:
		for planet in planets:
			ship.apply_force(gravity_force(ship, planet))
