extends Node3D

@onready var bridge_area:= $BridgeArea
@onready var pig1:= $Characters/Pig1
@onready var pig2:= $Characters/Pig2
@onready var pig3:= $Characters/Pig3
@onready var wolf:= $Characters/Wolf

@onready var prop_exclamation_mark:= $sm_exclamation_mark
@onready var prop_balloon:= $sm_balloon_01

var array_pigs: Array = [pig1, pig2, pig3]
var can_start_dialogue = true
var current_dialogue: int = 0 

func _ready() -> void: 
	assert(bridge_area.body_entered.connect(_bridge_area_entered) == OK)


func _bridge_area_entered(_body) -> void:
	#prop_balloon.global_position = pig1.global_position + InteractionManager.interaction_sprite_y_offset
	#prop_balloon.visible = true
	if can_start_dialogue && current_dialogue == 0: 
		current_dialogue += 1
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start(Utils.DIALOGUE_EXERCISE1)


func _on_timeline_ended() -> void: 
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	can_start_dialogue = false
	
	if current_dialogue == 1:
		wolf.visible = true 
		wolf.set_next_target()

func _input(_event):
	if Dialogic.current_timeline != null: 
		return 
