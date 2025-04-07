extends Node2D

@onready var sprite = $Dropper/Sprite2D
@onready var start = $Dropper/Start
@onready var stop = $Dropper/Stop


@onready var trans_button = $"Control/Panel/VBoxContainer/TRANSOptionButton"
@onready var ease_button = $Control/Panel/VBoxContainer/EaseButton
@onready var time_editor = $Control/Panel/VBoxContainer/TIMETextEdit
@onready var back_and_forth_check = $Control/Panel/VBoxContainer/BackAndForthCheckbox
@onready var forever_check = $Control/Panel/VBoxContainer/ForeverCheckbox
@onready var go_button = $Control/Panel/VBoxContainer/GOButton

@onready var transition_type = Tween.TRANS_LINEAR
@onready var ease_type = Tween.EASE_IN
@onready var drop_time = 1.

var transitions = {
	"LINEAR": Tween.TRANS_LINEAR,
	"SINE": Tween.TRANS_SINE,
	"QUINT": Tween.TRANS_QUINT,
	"QUART": Tween.TRANS_QUART,
	"QUAD": Tween.TRANS_QUAD,
	"EXPO": Tween.TRANS_EXPO,
	"ELASTIC": Tween.TRANS_ELASTIC,
	"CUBIC": Tween.TRANS_CUBIC,
	"CIRC": Tween.TRANS_CIRC,
	"BOUNCE": Tween.TRANS_BOUNCE,
	"BACK": Tween.TRANS_BACK,
}

var eases = {
	"IN" : Tween.EASE_IN,
	"OUT" : Tween.EASE_OUT,
	"IN OUT":Tween.EASE_IN_OUT,
	"OUT IN":Tween.EASE_OUT_IN
}
#
#@onready var transition_type = transitions[trans_button.get_item_text()]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	process_input()

func setup():
	drop_setup(true)
	populate_transition_button()
	populate_ease_button()
	go_button.connect("button_up", self._on_go_button_button_up)

func swap_startstop():
	print("swaterswapin")
	var temp_position = start.position
	start.position = stop.position
	stop.position = temp_position

func drop_setup(first_time = false):
	if back_and_forth_check.button_pressed and not first_time:
		swap_startstop()
	sprite.position = start.position

func populate_transition_button():
	for transition_name in transitions.keys():
		trans_button.add_item(transition_name)
		
func populate_ease_button():
	for ease_name in eases.keys():
		ease_button.add_item(ease_name)

func process_input():
	report_input()
	if Input.is_action_just_released("go"):
		go_button.button_pressed = false
		self._on_go_button_button_up() #buttons don't have press and release methods?
	if Input.is_action_pressed("go"):
		go_button.button_pressed = true
	if Input.is_action_just_pressed("unfocus"):
		pass
		

func report_input():
	if Input.is_action_just_pressed("ui_up"):
		print('up')
	if Input.is_action_just_pressed("ui_down"):
		print('down')
	if Input.is_action_just_pressed("ui_up"):
		print('left')
	if Input.is_action_just_pressed("ui_down"):
		print('right')
	if Input.is_action_just_pressed("go"):
		print('go pressed')
		get_viewport().set_input_as_handled()
		var focus = get_viewport().gui_get_focus_owner()
		if focus:
			focus.release_focus()
	if Input.is_action_just_released("go"):
		print('go released')



func drop():
	drop_setup()
	var drop_tween = self.create_tween()
	drop_tween.tween_property(sprite, "position", stop.position, drop_time).set_trans(transition_type).set_ease(ease_type)
	await drop_tween.finished
	#if forever_check.button_pressed:
		#await drop()
	return drop_tween

func _on_go_button_button_up() -> void:
	if not go_button.disabled:
		go_button.disabled = true
		await drop()
		while forever_check.button_pressed:
			await drop()
		go_button.disabled = false

func _on_trans_option_button_item_selected(index: int) -> void:
	var item_name = trans_button.get_item_text(index)
	transition_type = transitions[item_name]

func _on_ease_button_item_selected(index: int) -> void:
	var ease_name = ease_button.get_item_text(index)
	ease_type = eases[ease_name]

func unfocus():
	pass
	
func is_number(text: String) -> bool:
	return String(text).is_valid_float()

func _on_time_text_edit_text_changed() -> void:
	if is_number(time_editor.text):
		drop_time = float(time_editor.text)
