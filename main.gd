extends Node2D

var planets
var ships
var creatures

const G = 1e11

func _ready() -> void:
	planets = get_tree().get_nodes_in_group("planets")
	ships = get_tree().get_nodes_in_group("ships")
	creatures = get_tree().get_nodes_in_group("creatures")
	
	for planet in planets:
		for ship in ships:
			planet.connect("body_entered", func(body): _on_crash(body, planet))
	
func _on_crash(ship, planet):
	ship.crash()
	for creature in creatures:
		if (ship.global_position - creature.global_position).length() < ship.EXPLOSION_RADIUS:
			creature.die()
	print(ship, planet)

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
		if ship.alive:
			for planet in planets:
				var force = delta * gravity_force(ship, planet)
				ship.apply_force(force)
