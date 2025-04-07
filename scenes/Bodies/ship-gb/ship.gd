extends "res://scenes/Bodies/GravityBody/gravity_body.gd"

var engine_accel = 100 #px/sec

@onready var exhaust_sprite = $Sprite2D/ExhaustSprite2D

func _ready():
	super()
	exhaust_sprite.hide()

func _process(delta):
	super(delta)
	face_forward()
	handle_input(delta)

func handle_input(delta):
	if Input.is_action_just_pressed('ui_up'):
		print('firing engine')
		exhaust_sprite.show()
	if Input.is_action_just_released("ui_up"):
		print('engine off')
		exhaust_sprite.hide()
		print(linear_velocity)
	if Input.is_action_pressed('ui_up'):
		fire_engine(delta)
		
	if Input.is_action_just_pressed('ui_down'):
		print('firing engine')
		exhaust_sprite.rotation = PI
		exhaust_sprite.show()
	if Input.is_action_just_released("ui_down"):
		print('engine off')
		exhaust_sprite.rotation = 0
		exhaust_sprite.hide()
		print(linear_velocity)
	if Input.is_action_pressed("ui_down"):
		fire_engine(delta, true)

func fire_engine(dt, reverse = false):
	var dv = dt*engine_accel
	if reverse:
		dv = -dv
	self.throttle(dv)

func face_forward():
	var current_velocity = self.linear_velocity
	sprite2D.rotation = current_velocity.angle() - PI/2
