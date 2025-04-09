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
	get_group_bodies() #needs to be redone if any bodies leave or enter the scene. Should this just be done in accelerate_reactive_bodies?
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	accelerate_reactive_bodies(delta)
	var ship = get_tree().get_first_node_in_group('ships')
	draw_orbits(ship)

#does Gravity need to track these?
func get_group_bodies():
	gravity_bodies = get_tree().get_nodes_in_group("gravity_bodies")
	massive_bodies = get_tree().get_nodes_in_group("massive_bodies")
	reactive_bodies = get_tree().get_nodes_in_group("reactive_bodies")

func potential_single(x, y, massive_body):
	""" calculate the potential at x, y """
	var V = - massive_body.mass / massive_body.position.distance_to(Vector2(x,y))
	return V

func potential(x, y):
	""" calculate the potential at x, y """
	var V = 0.
	for massive_body in massive_bodies:
		V = V + potential_single(x,y,massive_body)
	return potential


func acceleration_single(x, y, massive_body):
	""" calculate the acceleration at x, y due to massive_body"""
	var accel_direction = - (Vector2(x,y) - massive_body.position).normalized()
	var a = G * accel_direction * massive_body.mass / massive_body.position.distance_squared_to(Vector2(x,y))
	return a
	
func acceleration(x, y, exceptions = []):
	""" calculate the acceleration at x, y due to all massive_bodies sans exceptions"""
	var A = Vector2(0,0)
	for massive_body in massive_bodies:
		if massive_body not in exceptions:
			A = A + acceleration_single(x,y, massive_body)
			#print("accel direction " + str(accel_direction))
	return A
	
func accelerate_reactive_bodies(delta):
	""" for each reactive body, go thru all massive bodies to get local acceleration and change velocity """
	get_group_bodies()
	for reactive_body in reactive_bodies:
		var x = reactive_body.position.x
		var y = reactive_body.position.y
		reactive_body.accelerate(delta * acceleration(x, y, reactive_body.exception_bodies))
		#reactive_body.apply_force(reactive_body.mass * acceleration(x, y, reactive_body.exception_bodies))

func circular_orbit_velocity(reactive_body, massive_body, clockwise = false):
	"""Get the velocity of reactive_body to that of a circular orbit around the host massive_body"""
	var linear_speed = sqrt(G * massive_body.mass / reactive_body.position.distance_to(massive_body.position))
	var velocity_direction = reactive_body.position.direction_to(massive_body.position).rotated(PI/2)
	if clockwise:
		velocity_direction = -velocity_direction
	return linear_speed * velocity_direction

func circularize_orbit(reactive_body, massive_body, clockwise = false):
	"""Change the velocity of reactive_body to that of a circular orbit around the host massive_body"""
	var linear_speed = circular_orbit_velocity(reactive_body, massive_body, clockwise)
	reactive_body.linear_velocity = linear_speed

func get_orbit(reactive_body, massive_body, timestep = 0.1, max_time_ahead = 5) -> Line2D:
	"""Create a Line2D approximating the future path of the reactive_body around the massive_body,
	assuming the massive_body is not moving and no other massive_bodys"""
	var v = reactive_body.linear_velocity
	var x = reactive_body.position
	var trajectory = Line2D.new()
	trajectory.add_point(x)
	#var no_timesteps = max_time_ahead / timestep
	var time = 0
	while time < max_time_ahead:
		time += timestep
		var a = acceleration_single(x.x, x.y, massive_body)
		x = x + v*timestep + (1./2)*a*timestep**2 #make this better if needed
		v = v + a*timestep
		trajectory.add_point(x)
	return trajectory

func draw_orbit(reactive_body, massive_body, color = Color(1,1,1,1)):
	#print("Drawing orbits for " + str(reactive_body))
	var body1_orbit
	if reactive_body and massive_body:
		body1_orbit = get_orbit(reactive_body, massive_body)
		self.add_child(body1_orbit)
		body1_orbit.default_color = color
		body1_orbit.closed = false
		body1_orbit.width = 1
		body1_orbit.show()
		#print("Showing orbit between " + str(reactive_body) + " and " + str(massive_body))
	return body1_orbit	

func draw_orbits(ship):
	var massive_bodies = get_tree().get_nodes_in_group("massive_bodies")
	var orbits = []
	var orbit
	for massive_body in massive_bodies:
		orbit = draw_orbit(ship, massive_body)
		orbits.append(
			orbit
		)
	var timer = get_tree().create_timer(0.05) #time to show orbits
	await timer.timeout
	for orb in orbits:
		orb.queue_free()

#func draw_orbits(ship, update_time = 2):
	#var timer = get_tree().create_timer(update_time)
	#var massive_bodies = get_tree().get_nodes_in_group("massive_bodies")
	#var orbits = []
	#var orbit
	#for massive_body in massive_bodies:
		#orbit = draw_orbit(ship, massive_body, Color(.6,.8,1,0.4))
		#orbits.append(
			#orbit
		#)
	#await timer.timeout
	#draw_orbits(ship, update_time)
	
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

	
