extends Area2D

signal win
@onready var shape = $CollisionShape2D
@onready var default_orbit = $Orbit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#default_orbit.circularize(200,Vector2(400,500), 10)
	await default_orbit.ready
	construct_segment_goal_from_orbit(default_orbit, 10)
	print('donezo')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func construct_segment_goal_from_orbit(the_orbit, width) -> void:
	"""Using a given orbit, add shape children to match.
	Maybe use "ConcavePolygonShape2D" or SegmentShape2D"""
	var orbit_points = the_orbit.points
	var segment_points = PackedVector2Array()
	for pointi in range(the_orbit.points.size - 1):
		#append the segment start point
		segment_points.append(orbit_points[pointi])
		#append the segment end point
		segment_points.append(orbit_points[pointi+1])
	#if the orbit is closed, close the shape too
	#(closed circle, not a closed disk)
	if the_orbit.closed:
		segment_points.append(orbit_points[-1])
		segment_points.append(orbit_points[0])
	shape.shape.points = segment_points
	
func fishing_style_goal(body, goal_time, grow_rate = 1, decay_rate = 1):
	"""grows a win meter when the body is intersecting,
	and lowers it (to zero) when the body is outside"""
	pass
	
func continuous_goal(body, goal_time):
	"""like fishing, but resets to zero immediately"""
	fishing_style_goal(body, goal_time, 1, 10**5)
