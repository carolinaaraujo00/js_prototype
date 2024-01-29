class_name HuffPuff extends Node3D

@onready var array_huff: Array = [$Cloud1, $Cloud2, $Cloud3]
@onready var array_shapes: Array = [$Circle, $Diamond, $Square, $Triangle]

var current_huff
var current_shape
var current_color


func new_huff(type) -> void: 
	current_huff = array_huff[randi() % array_huff.size()]
	current_huff.visible = true
	
	# huff (color) + no shape 
	if type == Utils.ENUM_HUFF_TYPE.HUFF1:
		current_color = _get_random_color()
		current_huff.modulate = current_color
		print("DEBUG: Creating huff type {0}, color {1}".format([type, current_color]))
	
	# huff + shape (no color) 
	elif type == Utils.ENUM_HUFF_TYPE.HUFF2:
		current_shape = array_shapes[randi() % array_shapes.size()]
		current_shape.visible = true
		print("DEBUG: Creating huff type {0}, shape {1}".format([type, current_shape]))
	
	# huff + shape (color)
	elif type == Utils.ENUM_HUFF_TYPE.HUFF3:
		current_color = _get_random_color()
		
		current_shape = array_shapes[randi() % array_shapes.size()]
		current_shape.visible = true
		current_shape.modulate = current_color 
		print("DEBUG: Creating huff type {0}, color {1}, shape {2}".format([type, current_color, current_shape]))
	
	else:
		return


func get_current_color() -> int:
	return Utils.DICT_COLORS.find_key(current_color)


func _get_random_color() -> Color:
	return Utils.DICT_COLORS.values()[randi() % Utils.DICT_COLORS.values().size()]