extends Node2D
@onready var spotlight = $Spotlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#tell the spotlight to follow the mouse
	follow_mouse()


func follow_mouse():
	spotlight.position = get_viewport().get_mouse_position()
