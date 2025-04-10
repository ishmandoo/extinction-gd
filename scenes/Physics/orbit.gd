extends Line2D

@export var decay_time = 0.2 #sec

var death_threshold = 0.05 #how bright it drops to before being removed
var current_acceleration = 1. #acceleration at the start. Used to color the orbit based on force strength

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_appearance()
	pass


func set_appearance(color = Color.WHITE, thickness = 1, joints = Line2D.LINE_JOINT_BEVEL):
	self.joint_mode = joints
	self.default_color = color
	self.width = thickness

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	decay_exp(delta, 1/decay_time)
	#decay_linear(delta, decay_time)
	
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
	
	
	
