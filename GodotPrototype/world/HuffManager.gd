extends Node3D

signal finished_exercise_round 

@onready var array_shapes: Array = [$wolf_huff_puff/Circle, $wolf_huff_puff/Diamond, $wolf_huff_puff/Square, $wolf_huff_puff/Triangle]
@onready var target_positions := $TargetPositions

const NO_COLOR = Color(0, 0, 0, 1)

var array_colors: Array = []
var huff_model
var number_huffs: int = 3 # +0 (round number), +1 (round number), +2 (round number)
var array_huff_correct_or_not: Array = []
var og_array_shapes: Array = []
var current_huffs: Array = []
var picked_colors: Array = []
var array_target_location: Array = []
var dict_answer: Dictionary = {}
var correct_answer_template = "Clica no {0}{1}!"
var correct_answer 

func _ready() -> void: 
	og_array_shapes = [] + array_shapes
	array_colors = [] + Utils.DICT_COLORS.values()
	huff_model = preload(Utils.SCENE_HUFF_AND_PUFF)
	
	for child in target_positions.get_children():
		if child.is_in_group(Utils.GROUP_TARGET_POSITION): 
			array_target_location.push_back(child.global_position)


func delete_previous_huffs() -> void: 
	print("deleting previous huffs")
	for i in current_huffs.size():
		current_huffs[i].queue_free()
	current_huffs = []


func create_round(current_round: int) -> void: 
	print("creating round")
	number_huffs += current_round
	var positions = array_target_location.slice(0, number_huffs)
	
	# array of false and one random true (just one answer is true) 
	array_huff_correct_or_not = []
	array_huff_correct_or_not.resize(number_huffs)
	array_huff_correct_or_not.fill(false)
	array_huff_correct_or_not[randi() % array_huff_correct_or_not.size()] = true
	
	print(array_huff_correct_or_not)
	
	var dict_shape_color: Dictionary = {}
	
	for i in number_huffs:
		var curr_huff = huff_model.instantiate()
		current_huffs.append(curr_huff)
		add_child(curr_huff)
		
		curr_huff.new_huff(array_huff_correct_or_not[i])
		assert(curr_huff.clicked_huff.connect(_on_huff_clicked) == OK)
		
		# huff (color) + no shape 
		if current_round == Utils.ENUM_HUFF_TYPE.HUFF1:
			curr_huff.set_huff_color(_get_random_color())
		
		# huff + shape (no color) 
		elif current_round == Utils.ENUM_HUFF_TYPE.HUFF2:
			curr_huff.set_shape(_get_random_shape(), NO_COLOR)
		
		# huff + shape (color)
		else: 
			# avoid having the same shape with the same color 
			var shape = _get_random_shape()
			var color = _get_random_color()
			while dict_shape_color.has(shape) && dict_shape_color[shape] == color: 
				print(dict_shape_color)
				color = _get_random_color()
			
			dict_shape_color[shape] = color
			curr_huff.set_shape(shape, color)
		
		if array_huff_correct_or_not[i]: 
			_create_correct_answer(curr_huff, current_round)
		curr_huff.global_position = positions[i]


func _create_correct_answer(huff: HuffPuff, round: int) -> void: 
	if round == Utils.ENUM_HUFF_TYPE.HUFF1:
		correct_answer = correct_answer_template.format([_get_color_name(huff.current_color), ""])
	elif round == Utils.ENUM_HUFF_TYPE.HUFF2: 
		correct_answer = correct_answer_template.format([_get_shape_name(huff.current_shape), ""])
	else: 
		correct_answer = correct_answer_template.format([_get_shape_name(huff.current_shape), " " + _get_color_name(huff.current_color)])
	
	print(correct_answer)
	Dialogic.VAR.correct_answer = correct_answer
	print(Dialogic.VAR.get('correct_answer'))


func _on_huff_clicked(is_correct: bool) -> void: 
	print("huff manager, is correct? {0}".format([is_correct]))
	if is_correct:
		delete_previous_huffs()
		finished_exercise_round.emit()


func _get_random_shape() -> Sprite3D: 
	# dont repeat shapes until every shape has been picked
	# reset shapes when already went through all 
	if array_shapes.size() == 0: array_shapes = [] + og_array_shapes
	return array_shapes.pop_at(randi() % array_shapes.size())


func _get_random_color() -> Color:
	# dont repeat colors until every color has been picked
	# and resets the picked color array after each round
	if picked_colors.size() == 0: picked_colors = [] + Utils.DICT_COLORS.values()
	return picked_colors.pop_at(randi() % picked_colors.size())


func _get_color_name(color: int) -> String:
	if color == Utils.ENUM_COLORS.AMARELO:
		return "amarelo"
	elif color == Utils.ENUM_COLORS.AZUL:
		return "azul"
	elif color == Utils.ENUM_COLORS.VERDE:
		return "verde"
	elif color == Utils.ENUM_COLORS.VERMELHO:
		return "vermelho"
	return ""


func _get_shape_name(shape: Sprite3D) -> String:
	if shape.name.to_lower() == "triangle": 
		return "triângulo"
	elif shape.name.to_lower() == "circle": 
		return "círculo"
	elif shape.name.to_lower() == "square": 
		return "quadrado"
	elif shape.name.to_lower() == "diamond": 
		return "losango"
	return ""
