extends Node2D
@onready var gravity = $Gravity
@onready var window_size = get_window().size
#@onready var star = $"Star"
@onready var star = $Star
@onready var ship = $Ship
@onready var planet = $Star/Rail/Planet
@onready var planet_rail = $Star/Rail

var oreo_scene = preload("res://scenes/Bodies/oreo-gb/oreoGB.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#planet1.scale_sprite_and_colliders(Vector2(0.5,0.5), 1)
	#planet2.scale_sprite_and_colliders(Vector2(0.5,0.5), 2)
	gravity.circularize_orbit(ship, star)
	planet_rail.circularize(400)
	planet.position = planet_rail.get_point_position(0)
	gravity.circularize_orbit(planet, star)
	gravity.get_group_bodies()
	#gravity.place_center_of_mass(gravity.gravity_bodies, Vector2(window_size/2), Vector2())
	create_oreo_grid(10,20, Vector2(30,0))
	
	star.linear_velocity = Vector2.ZERO
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
		
func create_oreo(coordinates, velocity = Vector2(0,0)):
	var new_oreo = oreo_scene.instantiate()
	new_oreo.add_to_group("oreos")
	self.add_child(new_oreo)
	#need to set velocity and position after adding cuz they depend on parent
	new_oreo.linear_velocity = velocity
	new_oreo.global_position = coordinates

func create_oreo_grid(rows:int, cols:int, velocity = Vector2(0,0), Roffset = 64, Coffset = 80):
	var Rspacing = window_size.y / rows
	var Cspacing = window_size.x / cols
	var offset = Vector2(Roffset, Coffset)
	#var coords = []
	for row in range(rows):
		for col in range(cols):
			#coords.append(offset + Vector2(Rspacing*row, Cspacing*col))
			create_oreo(offset + Vector2(Cspacing*col, Rspacing*row), velocity)
	return null
