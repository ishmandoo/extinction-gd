extends RigidBody2D

#local gravity. Not the G Gravity uses by default
@onready var G = 4*PI*PI *10000

#drag to impose on entering flyby bodies
@export var flyby_damping = 1.
#var space_damping = 0.0

#minimum flyby velocity that doesn't kill. orbital velocity at radius,
#needs to ask Gravity for G and circularize_orbit_velocity function
var death_speed = 0

#sprite
@export var size_scale:float
@onready var sprite2D = $"Sprite2D"

#collision
@onready var bodyarea = $BodyArea
@onready var dragarea = $DragArea

#visuals for editing
@onready var guide = $Guide
@export var label = ""

#const au = 200 #pixels
#@onready var window_size = get_window().size

#to be used for on-rails circles
var center = Vector2(0,0)

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
	
	make_connections()
	
	self.set_label()
	#collisions and sizing
	scale_sprite_and_colliders(size_scale*Vector2(1,1))
	set_contact_monitor(true) #collision detection
	max_contacts_reported = 10 #limit collisions
	
	#don't self-interact
	if is_massive:
		self.add_exception(self)
		
	self.add_to_groups()
	self.set_linear_velocity(velocity_start)
	#self.set_position(position_start)
	hide_guide()
	self.flash(Color(1,1,1,1), 2)
	print(str(self) + ": done setup!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#orbit(delta)
	#print(str(self) + " reporting in!")
	pass

###############
#### Setup ####
###############
		
func make_connections():
	bodyarea.connect("area_entered", _on_body_area_entered)
	bodyarea.connect("area_exited", _on_body_area_exited)
	
func set_label():
	#set the label text
	$Guide/LabelPanel/Label.text = label #testing label
	#if unlabeled, remove the panel over the sprite
	if label == '':
		$Guide/LabelPanel.queue_free()

func add_to_groups():
	"""
	groups determine how gravity work
	"""
	self.add_to_group("gravity_bodies")
	if is_massive:
		self.add_to_group("massive_bodies")
	if is_reactive:
		self.add_to_group("reactive_bodies")
	bodyarea.add_to_group("body_areas")
	dragarea.add_to_group("drag_areas")

func scale_sprite_and_colliders(scale_xy:Vector2, time = 0):
	if time == 0:
		sprite2D.scale = scale_xy
		bodyarea.scale = scale_xy
		dragarea.scale = scale_xy
	else:
		var scaler = get_tree().create_tween()
		scaler.tween_property(sprite2D, "scale", scale_xy, time)
		scaler.tween_property(bodyarea, "scale", scale_xy, time)
		scaler.tween_property(dragarea, "scale", scale_xy, time)

	

##########################
#### appearance ##########
##########################

func flash(peak_color:Color, timedown = 5, timeup = 0.05):

	var initial_color = self.modulate
	
	var flasher = get_tree().create_tween()
	flasher.tween_property(sprite2D, "modulate", peak_color, timeup)
	flasher.tween_property(sprite2D, "modulate", initial_color, timedown).set_trans(Tween.TRANS_LINEAR)

func show_guide():
	""" Shows labels """
	guide.show()

func hide_guide():
	""" Removes labels """
	guide.hide()

######################
#### acceleration ####
######################

func accelerate(dV:Vector2): #this has to change to make sure it's not screwing up the physics engine.
	#bad things happen when you set the linear_velocity manually --- use apply_impulse or similar.
	#but it seems proper for gravity to operate with accelerations rather than forces.
	""" add a vector to velocity """
	self.linear_velocity = self.linear_velocity + dV
	#self.apply_impulse(dV*self.mass)

func throttle(dV:float):
	""" add speed in direction of movement """
	var velocity_direction = linear_velocity.normalized()
	if velocity_direction != Vector2.ZERO:
		linear_velocity = (dV + linear_velocity.length()) * velocity_direction

	

############################
#### gravity exceptions ####
############################
# for flyovers. When an orbiter overlaps with a massive object, it ignores
# that object's gravity

# these aren't working. Not emotting a signal when the bodies overlap.
# contact monitor and contact report count are set in _ready()

func add_exception(gravity_body):
	exception_bodies.append(gravity_body)
	#print(str(self) + ' adding exception body ' + str(gravity_body))
	
func remove_exception(gravity_body):
	exception_bodies.erase(gravity_body)
	#print(str(self) + ' removing exception body ' + str(gravity_body))
#
func begin_flyby(parent_body):
	#"""excludes a nearby massive GravityBody when close"""
	self.linear_damp += parent_body.flyby_damping
	add_exception(parent_body)
	
func end_flyby(parent_body):
	#"""resumes acceleration toward a nearby GravityBody"""
	remove_exception(parent_body)

func update_drag(value:float):
	self.linear_damp += value

func _on_body_area_entered(area: Area2D) -> void:
	if area in get_tree().get_nodes_in_group('body_areas') and self.can_flyby:
		begin_flyby(area.get_parent())
	elif area in get_tree().get_nodes_in_group('drag_areas'):
		update_drag(area.get_parent().flyby_damping)

func _on_body_area_exited(area: Area2D) -> void:
	if area in get_tree().get_nodes_in_group('body_areas') and self.can_flyby:
		end_flyby(area.get_parent())
	elif area in get_tree().get_nodes_in_group('drag_areas'):
		update_drag(-area.get_parent().flyby_damping)
