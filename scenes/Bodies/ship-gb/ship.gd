extends "res://scenes/Bodies/GravityBody/gravity_body.gd"

var engine_accel = 200 #?/sec
@onready var magic_area_L = $MagicAreaL
@export var magic_L_strength = 100

@onready var magic_area_R = $MagicAreaR
@export var magic_R_strength = 100

# control LOCKED is the intended gameplay - only accelerate in direction of movement
# FREE includes the ability to rotate manually
enum Control_Mode {FREE, LOCKED}
@export var control_mode: Control_Mode = Control_Mode.LOCKED


@onready var exhaust_sprite = $Sprite2D/ExhaustSprite2D


func _ready():
	super()
	add_to_group('ships')
	exhaust_sprite.hide()

func _process(delta):
	super(delta)
	if control_mode == Control_Mode.LOCKED:
		face_forward()
	handle_input(delta)

	
	
#################################
### Inpunt ######################
#################################

func handle_input(delta):
	handle_ui_input()
	handle_maneuver_input(delta)
	handle_magic_input(delta) #spells and ship
	
func handle_maneuver_input(delta):
	if control_mode == Control_Mode.FREE:
		handle_asteroids_input(delta)
	elif control_mode == Control_Mode.LOCKED:
		handle_rails_input(delta)
	else:
		print(str(self) + " Bad control_mode!")
		
func handle_rails_input(delta):
	#normal controls
	if Input.is_action_just_pressed('accelerate_a'):
		print('speed up')
		exhaust_sprite.show()
	if Input.is_action_just_released("accelerate_a"):
		print('slow down')
		exhaust_sprite.hide()
		#print(linear_velocity)
	if Input.is_action_pressed('accelerate_a'):
		self.throttle(delta * engine_accel)
		
	if Input.is_action_just_pressed('decelerate_a'):
		print('firing reverse')
		exhaust_sprite.rotation = PI
		exhaust_sprite.show()
	if Input.is_action_just_released("decelerate_a"):
		print('reverse off')
		exhaust_sprite.rotation = 0
		exhaust_sprite.hide()
		#print(linear_velocity)
	if Input.is_action_pressed("decelerate_a"):
		self.throttle(-delta * engine_accel)

func handle_asteroids_input(delta):
	if Input.is_action_just_pressed('accelerate_a'):
		print('firing engine')
		exhaust_sprite.show()
	if Input.is_action_just_released("accelerate_a"):
		print('engine off')
		exhaust_sprite.hide()
		#print(linear_velocity)
	if Input.is_action_pressed('accelerate_a'):
		fire_engine(delta)
		
	if Input.is_action_just_pressed('decelerate_a'):
		print('firing reverse')
		exhaust_sprite.rotation = PI
		exhaust_sprite.show()
	if Input.is_action_just_released("decelerate_a"):
		print('reverse off')
		exhaust_sprite.hide()
		exhaust_sprite.rotation = 0
		#print(linear_velocity)
	if Input.is_action_pressed("decelerate_a"):
		fire_engine(delta, true)

	if Input.is_action_pressed("left_a"):
		angular_velocity = -PI
	if Input.is_action_pressed("right_a"):
		angular_velocity = PI
	if Input.is_action_just_released("left_a"):
		angular_velocity = 0
	if Input.is_action_just_released("right_a"):
		angular_velocity = 0

func handle_ui_input():
	if Input.is_action_just_pressed("toggle_controlmode"):
		label
		toggle_controlmode()		
	
func toggle_controlmode():
	if control_mode == Control_Mode.FREE:
		control_mode = Control_Mode.LOCKED
		self.label_tag.text = "ship (turning locked)"
		#print("Locked control mode")
	else:
		control_mode = Control_Mode.FREE
		self.label_tag.text = "ship (free control)"
		#print("Free control mode")

func handle_magic_input(delta):
	if Input.is_action_just_pressed("magic_left_a"):
		engage_left_magic()
	elif Input.is_action_pressed("magic_left_a"):
		var magical_bodies = magic_area_L.get_overlapping_bodies()
		#print(magical_bodies)
		for body in magical_bodies:
			if body.is_reactive:
				body.accelerate(delta*magic_L_strength*self.linear_velocity.normalized())
				
	if Input.is_action_just_released("magic_left_a"):
		disengage_left_magic()
		
	if Input.is_action_just_pressed("magic_right_a"):
		engage_right_magic()
	elif Input.is_action_pressed("magic_right_a"):
		var magical_bodies = magic_area_R.get_overlapping_bodies()
		#print(magical_bodies)
		for body in magical_bodies:
			if body.is_reactive:
				body.accelerate(-delta*magic_R_strength*self.linear_velocity.normalized())
	if Input.is_action_just_released("magic_right_a"):
		disengage_right_magic()

################
#### moving ####
################
		
func fire_engine(dt, reverse = false):
	var dv = dt*engine_accel*Vector2.from_angle(self.rotation)
	if reverse:
		dv = -dv
	self.accelerate(dv)

func face_forward(rotation_rate = 5):
	var current_velocity = self.linear_velocity
	#only does anything if it's actually moving
	if current_velocity.length() > .01:
		#const rotation_offset = -PI/2
		var target_angle = current_velocity.angle()# + rotation_offset
		if abs(target_angle - self.rotation) > PI:
			target_angle = target_angle - 2*PI
		#print("----------------------")
		#print("target angle: " + str(target_angle))
		#print("rotation: " + str(self.rotation))
		#print("difference: " + str(target_angle - self.rotation))
		#sprite2D.rotation = new_angle
		#dragarea.rotation = new_angle
		#bodyarea.rotation = new_angle
		self.angular_velocity = rotation_rate * (target_angle - self.rotation)

######################
#### spellcasting ####
######################

func engage_right_magic():
	magic_area_R.show()
	
func disengage_right_magic():
	magic_area_R.hide()
	
func engage_left_magic():
	magic_area_L.show()
	
func disengage_left_magic():
	magic_area_L.hide()
	
	
