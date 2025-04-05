extends Control

const au = 128 #pixels
###### get the units and value of G right. agree with the acceleration, dist per pixel and time.
const G = 4*PI*PI *10000  #units au, year, Msun

# tracking bodies with different behaviors
@onready var reactive_bodies = []
@onready var massive_bodies = []
@onready var flyby_bodies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_group_bodies() #needs to be redone if the system changes. Should this just be done in accelerate_reactive_bodies?
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	accelerate_reactive_bodies(delta)

func get_group_bodies():
	reactive_bodies = get_tree().get_nodes_in_group("reactive_bodies")
	massive_bodies = get_tree().get_nodes_in_group("massive_bodies")
	flyby_bodies = get_tree().get_nodes_in_group("flyby_bodies")
	for flyby_body in flyby_bodies:
		flyby_body.connect

# alternatively take a Vector2?
func potential(x, y):
	""" calculate the potential at x, y """
	var V = 0.
	for massive_body in massive_bodies:
		V = V - massive_body.mass / massive_body.position.distance_to(Vector2(x,y))
	return potential

#alternatively take a Vector2?
func acceleration(x, y, exceptions = []):
	""" calculate the acceleration at x, y due to all massive_bodies """
	var A = Vector2(0,0)
	for massive_body in massive_bodies:
		if massive_body not in exceptions:
			var accel_direction = - (Vector2(x,y) - massive_body.position).normalized()
			A = A + G * accel_direction * massive_body.mass / massive_body.position.distance_squared_to(Vector2(x,y))
			#print("accel direction " + str(accel_direction))
	return A
	
func accelerate_reactive_bodies(delta):
	""" for each reactive body, go thru all massive bodies to get local acceleration and change velocity """
	get_group_bodies()
	for reactive_body in reactive_bodies:
		var x = reactive_body.position.x
		var y = reactive_body.position.y
		reactive_body.accelerate(delta * acceleration(x, y, reactive_body.exception_bodies))
