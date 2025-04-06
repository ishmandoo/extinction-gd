extends Node2D

@onready var sprite = $Sprite2D
@onready var start = $Start
@onready var stop = $Stop
@onready var trans_button = $"Control/Panel/VBoxContainer/TRANSOptionButton"
@onready var time_editor = $Control/Panel/VBoxContainer/TIMETextEdit

var transitions = {
		0:Tween.TRANS_SINE,
		1:Tween.TRANS_LINEAR
	}

@onready var transition_type = transitions[trans_button.selected]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup():
	sprite.position = start.position

func drop(time, transition):
	setup()
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", stop.position, time).set_trans(transition)

func _on_go_button_button_up() -> void:
	drop(float(time_editor.text), transition_type)


func _on_trans_option_button_item_selected(index: int) -> void:
	transition_type = transitions[index]
