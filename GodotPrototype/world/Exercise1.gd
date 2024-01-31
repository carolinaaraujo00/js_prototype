extends Node3D

@onready var bridge_area := $BridgeArea
@onready var pig1 := $Characters/Pig1
#@onready var pig2 := $Characters/Pig2
#@onready var pig3 := $Characters/Pig3
@onready var wolf := $Characters/Wolf
@onready var player := $Characters/Player/CharacterBody3D
@onready var huff_manager := $HuffManager

#var array_pigs: Array = [pig1, pig2, pig3]
var array_pigs: Array = [pig1]

var can_start_dialogue: bool = true
var current_dialogue: int = 0 
var current_round: int = 0


func _ready() -> void: 
	assert(bridge_area.body_entered.connect(_bridge_area_entered) == OK)
	assert(huff_manager.finished_exercise_round.connect(_finished_round) == OK)


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


func _finished_round() -> void: 
	if current_round < 2:
		current_round += 1 
		huff_manager.create_round(current_round)
		Dialogic.start(Utils.DIALOGUE_EXERCISE1_CORRECT_ANSWER)
		
	else: 
		player.set_block_movement(true)


func _on_wolf_reached() -> void: 
	# block movement and get player in optimal position to complete the exercise 
	player.set_position_and_block(bridge_area.global_position, false)
	wolf.npc_target_reached.disconnect(_on_wolf_reached)
	huff_manager.create_round(current_round)
	Dialogic.start(Utils.DIALOGUE_EXERCISE1_CORRECT_ANSWER)


func _input(event):
	if event.is_action_pressed(Utils.ACTION_DEBUG) && current_round == 0:
		huff_manager.create_round(current_round)
