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
	# TODO move player to optimal position 
	wolf.npc_target_reached.disconnect(_on_wolf_reached)


func _input(event):
	if event.is_action_pressed(Utils.ACTION_DEBUG):
		if huff_manager.current_huffs.size() != 0:
			for i in huff_manager.current_huffs.size():
				huff_manager.current_huffs[i].visible = false
		
		huff_manager.create_round(current_round)
		if current_round <= 2:
			current_round += 1 


func _on_huff_clicked(is_huff_correct: bool) -> void: 
	if is_huff_correct:
		print("is true")
	else: 
		print("is false")
