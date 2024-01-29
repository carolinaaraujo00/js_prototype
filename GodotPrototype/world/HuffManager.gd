extends Node3D

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

func _ready() -> void: 
	og_array_shapes = [] + array_shapes
	array_colors = [] + Utils.DICT_COLORS.values()
	huff_model = preload(Utils.SCENE_HUFF_AND_PUFF)
	
	for child in target_positions.get_children():
		if child.is_in_group(Utils.GROUP_TARGET_POSITION): 
			array_target_location.push_back(child.global_position)

# reset method (dictionary, etc)
# queue free 
# huff manager to know which colors/symbols have been assigned 

func create_round(current_round: int) -> void: 
	number_huffs += current_round
	var positions = array_target_location.slice(0, number_huffs)
	
	# array of false and one random true (just one answer is true) 
	array_huff_correct_or_not.resize(number_huffs)
	array_huff_correct_or_not.fill(false)
	array_huff_correct_or_not[randi() % array_huff_correct_or_not.size()] = true
	
	for i in number_huffs:
		var curr_huff = huff_model.instantiate()
		add_child(curr_huff)
		
		#func new_huff(correct: bool, huff: Sprite3D, shape: Sprite3D) -> void: 
		curr_huff.new_huff(array_huff_correct_or_not[i])
		#assert(curr_huff.clicked_huff.connect(_on_huff_clicked) == OK)
		
		# huff (color) + no shape 
		if current_round == Utils.ENUM_HUFF_TYPE.HUFF1:
			curr_huff.set_huff_color(_get_random_color())
		
		# huff + shape (no color) 
		elif current_round == Utils.ENUM_HUFF_TYPE.HUFF2:
			curr_huff.set_shape(_get_random_shape(), NO_COLOR)
		
		# huff + shape (color)
		else: 
			curr_huff.set_shape(_get_random_shape(), _get_random_color())
		
		curr_huff.global_position = positions[i]
		current_huffs.push_back(curr_huff)


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
