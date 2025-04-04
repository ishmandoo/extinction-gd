extends StaticBody2D

@onready var guide = $EditorGuide

const au = 200 #pixels

const center = Vector2(960,540)/2
@onready var window_size = get_window().size

var G = 4*PI*PI #units au, year, Msun
@export var mass = 1 # Msuns. 
@export var orbital_period = 60 #sec
@export var orbital_distance = 1*au #au
const orbit_aspect_ratio = 9/16. # height/width
const phase_start = 0 #rad
var phase = phase_start 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("massive_bodies")
	setup_placement()
	hide_guide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit(delta)

func setup_placement():
	""" Place the body at self.center """
	var start_x = center.x + orbital_distance * cos(phase_start)
	var start_y = center.y + orbital_distance * sin(phase_start)
	position = Vector2(start_x, start_y)

func hide_guide():
	""" Removes editing labels """
	guide.hide()
	

func orbit(delta):
	phase = phase + delta * 2 * PI / orbital_period
	position.x = center.x + orbital_distance * cos(phase)
	position.y = center.y + orbital_distance * sin(phase)
