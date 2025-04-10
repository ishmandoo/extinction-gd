extends Control

@onready var space_button = $VBoxContainer/HBoxContainer/PanelContainer2/Panel/SpaceLevelButton
@onready var cow_button = $VBoxContainer/HBoxContainer3/PanelContainer3/Panel/CowLevelButton
@onready var space2_button = $VBoxContainer/HBoxContainer/PanelContainer3/Panel/Space2Button
@onready var spacemoon_button = $VBoxContainer/HBoxContainer/PanelContainer/Panel/OneMoonButton

var space_level_path = "res://scenes/Game.tscn"
var cow_level_path = "res://scenes/Worlds/cow-level/main.tscn"
var space2_level_path = "res://scenes/Game2.tscn"
var spacemoon_level_path = "res://scenes/GameMoon.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_buttons()

func connect_buttons():
	space_button.pressed.connect(self._on_space_button_pressed)
	cow_button.pressed.connect(self._on_cow_button_pressed)
	space2_button.pressed.connect(self._on_space2_button_pressed)
	spacemoon_button.pressed.connect(self._on_spacemoon_button_pressed)

func _on_space_button_pressed():
	switch_scene(space_level_path)

func _on_space2_button_pressed():
	switch_scene(space2_level_path)
	
func _on_cow_button_pressed():
	switch_scene(cow_level_path)

func _on_spacemoon_button_pressed():
	switch_scene(spacemoon_level_path)

func switch_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
