extends StaticBody2D

const au = 300 #pixels

const center = Vector2(960,540)
@onready var window_size = get_window().size

@export var orbital_period = 60 #sec
@export var orbital_distance = 1*au #au
const orbit_aspect_ratio = 9/16 # height/width
const phase_start = 0 #rad
var phase = phase_start 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_place()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit(delta)

func setup_place():
	var start_x = center.x + orbital_distance * cos(phase_start)
	var start_y = center.y + orbital_distance * sin(phase_start)
	position = Vector2(start_x, start_y)

func orbit(delta):
	phase = phase + delta * 2 * PI / orbital_period
	position.x = center.x + orbital_distance * cos(phase)
	position.y = center.y + orbital_distance * sin(phase)
