class_name MainMenu extends Control

@onready var play_button := $MarginContainer/HBoxContainer/VBoxContainer/play_button
@onready var quit_button := $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/quit_button

func _ready() -> void: 
	assert(play_button.pressed.connect(_on_play_button_pressed) == OK)
	assert(quit_button.pressed.connect(_on_quit_button_pressed) == OK)
	

func _on_play_button_pressed():
	get_tree().change_scene_to_file(Utils.SCENE_LVL0_THREE_LITTLE_PIGS)


func _on_quit_button_pressed():
	get_tree().quit()
