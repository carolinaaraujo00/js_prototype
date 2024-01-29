extends Node3D

@onready var bridge_area := $BridgeArea
@onready var pig1 := $Characters/Pig1
#@onready var pig2 := $Characters/Pig2
#@onready var pig3 := $Characters/Pig3
@onready var wolf := $Characters/Wolf
@onready var player := $Characters/Player/CharacterBody3D

@onready var array_target_location := [
	$TargetPositions/TargetPosition, 
	$TargetPositions/TargetPosition2, 
	$TargetPositions/TargetPosition3, 
	$TargetPositions/TargetPosition4, 
	$TargetPositions/TargetPosition5, 
	$TargetPositions/TargetPosition6
]

var dict_occupied_target_pos: Dictionary = {}

var huff_and_puff = preload(Utils.SCENE_HUFF_AND_PUFF)

#var array_pigs: Array = [pig1, pig2, pig3]
var array_pigs: Array = [pig1]
var array_number_puffs: Array = [3, 4, 6]
var can_start_dialogue: bool = true
var current_dialogue: int = 0 
var current_round: int = 2
var current_huffs: Array = []


func _ready() -> void: 
	assert(bridge_area.body_entered.connect(_bridge_area_entered) == OK)
	pig1.set_area_can_interact(true)
	for i in array_target_location.size():
		dict_occupied_target_pos[array_target_location[i]] = false


func _bridge_area_entered(_body) -> void:
	if can_start_dialogue && current_dialogue == 0: 
		current_dialogue += 1
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start(Utils.DIALOGUE_EXERCISE1)


func _on_timeline_ended() -> void: 
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	can_start_dialogue = false
	
	if current_dialogue == 1:
		wolf.visible = true 
		assert(wolf.npc_target_reached.connect(_on_wolf_reached) == OK)
		wolf.set_next_target()


func _on_wolf_reached() -> void: 
	player.block_movement(false)
	wolf.npc_target_reached.disconnect(_on_wolf_reached)


func _input(event):
	if event.is_action_pressed(Utils.ACTION_DEBUG):
		_create_round()


func _create_round() -> void:
	var array_correct = Array()
	array_correct.resize(array_number_puffs[current_round])
	array_correct.fill(false)
	array_correct[randi() % array_correct.size()] = true
	
	print(array_correct)
	
	for i in array_number_puffs[current_round]: 
		var curr_huff = huff_and_puff.instantiate()
		add_child(curr_huff)
		
		curr_huff.new_huff(current_round, array_correct[i])
		assert(curr_huff.clicked_huff.connect(_on_huff_clicked) == OK)
		current_huffs.push_back(curr_huff)
		
		
		var pos = randi() % array_target_location.size()
		while dict_occupied_target_pos[array_target_location[pos]]:
			pos = randi() % array_target_location.size()
		
		print(dict_occupied_target_pos)
		
		dict_occupied_target_pos[array_target_location[pos]] = true
		curr_huff.global_position = array_target_location[pos].global_position

# reset method (dictionary, etc)
# queue free 
# huff manager to know which colors/symbols have been assigned 

func _on_huff_clicked(is_huff_correct: bool) -> void: 
	if is_huff_correct:
		print("is true")
	else: 
		print("is false")
