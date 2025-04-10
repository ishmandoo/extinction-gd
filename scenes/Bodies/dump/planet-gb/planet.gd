extends "res://scenes/Bodies/GravityBody/gravity_body.gd"

@onready var dragarea = $DragArea
@export var atmospheric_drag = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


###################################
#### drag ###########
###########



func apply_drag(reactive_body):
	reactive_body.linear_drag += self.atmospheric_drag
	
func remove_drag(reactive_body):
	reactive_body.linear_drag -= self.atmospheric_drag
