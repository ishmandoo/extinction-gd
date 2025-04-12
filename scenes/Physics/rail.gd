extends Line2D

@export var snap_to_rail = false
@export var restoring_strength = .1
@export var max_restoring_acceleration = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attract_children(delta)

func circularize(center:Vector2, radius:float, no_points = 100):
	"""make the orbit a closed circle around
	the given center"""
	self.clear_points()
	for pointi in range(no_points):
		var pointx = radius*cos(2*PI*pointi/no_points)
		var pointy = radius*sin(2*PI*pointi/no_points)
		var new_point = center + Vector2(pointx,pointy)
		self.add_point(new_point)

func get_closest_point(pos: Vector2):
	var min_distance = 10**7
	var closest_point
	for point in self.points:
		var dist = pos.distance_to(point)
		if dist < min_distance:
			min_distance = dist
			closest_point = point
	return closest_point

func attract_child(delta, reactive_body):
	var closest_point = get_closest_point(reactive_body.position)
	print("closest point " + str(closest_point))
	print("Reactive body pos " + str(reactive_body.position))
	var accel_direction = -closest_point.direction_to(reactive_body.position)
	var acceleration = delta*restoring_strength*closest_point.distance_squared_to(reactive_body.position)
	acceleration = clamp(acceleration, 0, max_restoring_acceleration)
	reactive_body.accelerate(acceleration*accel_direction)
	
func attract_children(delta):
	for child in self.get_children():
		if child.is_reactive:
			#print("attracking gb")
			attract_child(delta, child)
