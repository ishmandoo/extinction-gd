extends "res://scenes/Bodies/GravityBody/gravity_body.gd"

var engine_accel = 100 #?/sec

@onready var exhaust_sprite = $Sprite2D/ExhaustSprite2D

func _ready():
	super()
	add_to_group('ships')
	exhaust_sprite.hide()

func _process(delta):
	super(delta)
	#face_forward()
	handle_input(delta)

func handle_input(delta):
	#arrow keys for asteroids controls
	handle_asteroids_input(delta)
	
	#normal controls
	if Input.is_action_just_pressed('accelerate'):
		print('speed up')
		exhaust_sprite.show()
	if Input.is_action_just_released("accelerate"):
		print('slow down')
		exhaust_sprite.hide()
		#print(linear_velocity)
	if Input.is_action_pressed('accelerate'):
		self.throttle(delta * engine_accel)
		
	if Input.is_action_just_pressed('decelerate'):
		print('firing reverse')
		exhaust_sprite.rotation = PI
		exhaust_sprite.show()
	if Input.is_action_just_released("decelerate"):
		print('reverse off')
		exhaust_sprite.rotation = 0
		exhaust_sprite.hide()
		#print(linear_velocity)
	if Input.is_action_pressed("decelerate"):
		self.throttle(-delta * engine_accel)

func handle_asteroids_input(delta):
	if Input.is_action_just_pressed('ui_up'):
		print('firing engine')
		exhaust_sprite.show()
	if Input.is_action_just_released("ui_up"):
		print('engine off')
		exhaust_sprite.hide()
		#print(linear_velocity)
	if Input.is_action_pressed('ui_up'):
		fire_engine(delta)
		
	if Input.is_action_just_pressed('ui_down'):
		print('firing reverse')
		exhaust_sprite.rotation = PI
		exhaust_sprite.show()
	if Input.is_action_just_released("ui_down"):
		print('reverse off')
		exhaust_sprite.rotation = 0
		exhaust_sprite.hide()
		#print(linear_velocity)
	if Input.is_action_pressed("ui_down"):
		fire_engine(delta, true)

	if Input.is_action_pressed("ui_left"):
		angular_velocity = -PI
	if Input.is_action_pressed("ui_right"):
		angular_velocity = PI
	if Input.is_action_just_released("ui_left"):
		angular_velocity = 0
	if Input.is_action_just_released("ui_right"):
		angular_velocity = 0

func fire_engine(dt, reverse = false):
	var dv = dt*engine_accel*Vector2.from_angle(self.rotation)
	if reverse:
		dv = -dv
	self.accelerate(dv)

func face_forward():
	var current_velocity = self.linear_velocity
	#sprite2D.rotation = current_velocity.angle() - PI/2
	self.rotation = current_velocity.angle() - PI/2
