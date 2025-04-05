extends RigidBody2D

#local gravity. Not the G Gravity uses by default
@onready var G = 4*PI*PI *10000

var flyby_damping = 1
var space_damping = 0.0

#sprite
@export var size_scale = 1
@onready var sprite2D = $"Sprite2D"

#collision
@onready var collider = $Area2D/CollisionShape2D

#visuals for editing
@onready var guide = $EditorGuide
@export var label = "<--- 127 px --->"

#const au = 200 #pixels
#@onready var window_size = get_window().size

#to be used for on-rails circlesm,
const center = Vector2(960,540)/2

@export var velocity_start: Vector2

## whether the GravityBody applies a gravitational field to reactive bodies
@export var is_massive:bool
#@export var mass:float # Msuns.

## whether the GravityBody accelerates due to gravity from other massive GravityBodies
@export var is_reactive:bool

## whether the GravityBody passes over a massive body without crashing
@export var can_flyby:bool

# massive bodies to ignore
# Gravity node reads this
var exception_bodies = []

# for circular orbits on rails
#@export var orbital_period = 60 #sec
#@export var orbital_distance = 1*au #au
#const orbit_aspect_ratio = 9/16. # height/width
#const phase_start = 0 #rad
#var phase = phase_start 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#set the label text
	$EditorGuide/LabelPanel/Label.text = label #testing label
	#if unlabeled, remove the panel over the sprite
	if label == '':
		$EditorGuide/LabelPanel.queue_free()
		
	#collisions
	set_contact_monitor(true) #collision detection
	max_contacts_reported = 10 #limit collisions
	
	#don't self-interact
	if is_massive:
		exception_bodies.append(self)
		
	self.add_to_groups()
	self.set_velocity(velocity_start)
	#set_placement()
	#hide_guide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#orbit(delta)
	pass

###############
#### Setup ####
###############

func add_to_groups():
	"""
	groups determine how gravity work
	"""
	self.add_to_group("gravity_bodies")
	if is_massive:
		self.add_to_group("massive_bodies")
	if is_reactive:
		self.add_to_group("reactive_bodies")

func set_velocity(velocity):
	linear_velocity = velocity

func set_placement():
	""" Place the body """
	var start_x = center.x
	var start_y = center.y
	position = Vector2(start_x, start_y)

func scale_sprite_and_colliders(scale_xy:Vector2, time = 0):
	if time == 0:
		sprite2D.scale = scale_xy
		collider.scale = scale_xy
	else:
		var scaler = get_tree().create_tween()
		scaler.tween_property(sprite2D, "scale", scale_xy, time)
		scaler.tween_property(collider, "scale", scale_xy, time)
		
func hide_guide():
	""" Removes editing labels """
	guide.hide()
	
######################
#### acceleration ####
######################

func accelerate(dV:Vector2):
	""" add a vector speed """
	linear_velocity = linear_velocity +  dV

func throttle(dV:float):
	""" add speed in direction of movement """
	linear_velocity = (dV + linear_velocity.length()) * linear_velocity.normalized()

func circularize_orbit(host_body):
	"""Change the velocity to that of a circular orbit around the host Massive Body"""
	var linear_speed = sqrt(G * host_body.mass / position.distance_to(host_body.position))
	var velocity_direction = position.direction_to(host_body.position).rotated(PI/2)
	linear_velocity = linear_speed * velocity_direction
	

############################
#### gravity exceptions ####
############################
# for flyovers. When an orbiter overlaps with a massive object, it ignores
# that object's gravity

# these aren't working. Not emotting a signal when the bodies overlap.
# contact monitor and contact report count are set in _ready()

func add_exception(gravity_body):
	exception_bodies.append(gravity_body)
	print('adding exception body')
	
func remove_exception(gravity_body):
	exception_bodies.erase(gravity_body)
	print('removing exception body')

func begin_flyby(parent_body):
	"""excludes a nearby massive GravityBody when close"""
	self.linear_damp = flyby_damping
	add_exception(parent_body)
	
func end_flyby(parent_body):
	"""resumes acceleration toward a nearby GravityBody"""
	self.linear_damp = space_damping
	remove_exception(parent_body)

func _on_area_2d_body_entered(body: Node) -> void:
	print("body entered!")
	if body.is_massive and self.can_flyby:
		begin_flyby(body)

func _on_area_2d_body_exited(body: Node) -> void:
	print("body exited!")
	if body.is_massive and self.can_flyby:
		end_flyby(body)
