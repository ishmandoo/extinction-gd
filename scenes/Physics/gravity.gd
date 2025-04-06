extends Control

const au = 128 #pixels
###### get the units and value of G right. agree with the acceleration, dist per pixel and time.
const G = 4*PI*PI *10000  #units au, year, Msun

# tracking bodies with different behaviors

@onready var gravity_bodies = []
@onready var massive_bodies = []
@onready var reactive_bodies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_group_bodies() #needs to be redone if the system changes. Should this just be done in accelerate_reactive_bodies?
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	accelerate_reactive_bodies(delta)

#does Gravity need to track these?
func get_group_bodies():
	gravity_bodies = get_tree().get_nodes_in_group("gravity_bodies")
	massive_bodies = get_tree().get_nodes_in_group("massive_bodies")
	reactive_bodies = get_tree().get_nodes_in_group("reactive_bodies")

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

func circularize_orbit(reactive_body, massive_body, clockwise = false):
	"""Change the velocity of reactive_body to that of a circular orbit around the host massive_body"""
	var linear_speed = sqrt(G * massive_body.mass / reactive_body.position.distance_to(massive_body.position))
	var velocity_direction = reactive_body.position.direction_to(massive_body.position).rotated(PI/2)
	if clockwise:
		velocity_direction = -velocity_direction
	reactive_body.linear_velocity = linear_speed * velocity_direction

func get_cm(bodies):
	"""center of mass of a list"""
	var cm = Vector2(0,0)
	for gravity_body in bodies:
		cm += gravity_body.mass * gravity_body.position
	cm = cm / bodies.size()
	return cm
		
func get_cm_velocity(bodies):
	"""mass averaged velocity"""
	var cmv = Vector2()
	for gravity_body in bodies:
		cmv += gravity_body.mass * gravity_body.linear_velocity
	cmv = cmv/bodies.size()
	return cmv
	

func place_center_of_mass(bodies, location, velocity = Vector2()):
	"""Move a group of bodies so CM is at location"""
	var cm = get_cm(bodies)
	var cmv = get_cm_velocity(bodies)
	var difference = location - cm
	for gravity_body in bodies:
		gravity_body.position += difference
		gravity_body.linear_velocity -= cmv
		gravity_body.linear_velocity += velocity
	return null

	
