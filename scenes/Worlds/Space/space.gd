extends Node2D
@onready var gravity = $Gravity
@onready var window_size = get_window().size
@onready var star = $"GravityBody Star"
@onready var planet1 = $"GravityBody Planet"
@onready var planet2 = $"GravityBody Planet2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	planet1.scale_sprite(Vector2(0.5,0.5))
	planet2.scale_sprite(Vector2(0.5,0.5))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
		
func create_oreo(coordinates, velocity = Vector2(0,0)):
	var oreo_prime = $Oreo
	var new_oreo = oreo_prime.duplicate()
	new_oreo.show()
	self.add_child(new_oreo)
	#need to set velocity and position after adding cuz they depend on parent
	new_oreo.set_velocity(velocity)
	new_oreo.position = coordinates

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
