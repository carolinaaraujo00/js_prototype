class_name HuffPuff extends Node3D

signal clicked_huff 

@onready var array_huff: Array = [$Cloud1, $Cloud2, $Cloud3]
@onready var array_shape: Array = [$Circle, $Square, $Triangle, $Diamond] 
@onready var interaction_area: InteractionArea = $InteractionArea

var current_huff
var current_color 
var current_shape
var is_correct: bool
var test_int: int = 0

var dict_shapes: Dictionary = {}


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	for i in array_shape.size(): 
		dict_shapes[array_shape[i].name] = array_shape[i]


func new_huff(correct: bool) -> void: 
	is_correct = correct
	
	current_huff = array_huff[randi() % array_huff.size()]
	current_huff.visible = true


func set_shape(shape: Sprite3D, color: Color) -> void:
	if dict_shapes.get(shape.name):
		current_shape = shape
		dict_shapes.get(shape.name).visible = true 
		
		if color: 
			current_color = Utils.DICT_COLORS.find_key(color)
			dict_shapes.get(shape.name).modulate = color


func set_huff_color(color: Color) -> void: 
	current_color = Utils.DICT_COLORS.find_key(color)
	print(current_color)
	current_huff.modulate = color


func _on_interact() -> void: 
	print("clicked prop, is correct? {0}".format([is_correct]))
	clicked_huff.emit(is_correct)
