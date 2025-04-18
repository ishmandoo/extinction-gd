extends Line2D

#how long it takes to completely decay appearance. With a positive death threshold, this
#is longer than the actual lifetime
@export var decay_time = 5. #sec

var death_threshold = 0.05 #how bright it drops to before being removed
var current_acceleration = 1. #acceleration at the start. Used to color the orbit based on force strength

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_appearance()
	#circularize(200, Vector2(400,500), 100)

	pass


func set_appearance(color = Color.WHITE, thickness = 1, joints = Line2D.LINE_JOINT_BEVEL):
	self.joint_mode = joints
	self.default_color = color
	self.width = thickness

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	decay_exp(delta, 1/decay_time)
	#decay_linear(delta, decay_time)

#################
#### drawing ####
#################

# Gravity uses orbit.add_point() to construct the orbits
# predicting the future path of the ship


func circularize(radius:float, center = Vector2.ZERO,  no_points = 100):
	"""make the orbit a closed circle around
	the given center by replacing any points with new points"""
	self.clear_points()
	for pointi in range(no_points):
		var pointx = radius*cos(2*PI*pointi/no_points)
		var pointy = radius*sin(2*PI*pointi/no_points)
		var new_point = center + Vector2(pointx,pointy)
		self.add_point(new_point)
	self.closed = true


##################
### visual #######
##################

func decay_linear(dt, decay_time):
	self.default_color = self.default_color - (dt/decay_time)*Color.WHITE
	check_pulse(death_threshold)
	
func decay_exp(dt, time_scale):
	const color_death_threshold = 0.05 #how luminous the line drops to trigger freeing
	self.default_color = (1 - dt*time_scale) * self.default_color
	check_pulse(death_threshold)

func check_pulse(threshold):
	"""Checks if the luminance is under the threshold and frees the orbit if so"""
	if self.default_color.get_luminance() < threshold:
		queue_free()
	
	
	
