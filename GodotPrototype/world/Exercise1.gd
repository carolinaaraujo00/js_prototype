extends Node3D

@onready var bridge_area := $BridgeArea
@onready var pig1 := $Characters/Pig1
@onready var pig2 := $Characters/Pig2
@onready var pig3 := $Characters/Pig3
@onready var wolf := $Characters/Wolf
@onready var player := $Characters/Player/CharacterBody3D

@onready var debug_target_location := $TargetPosition

var array_pigs: Array = [pig1, pig2, pig3]
var can_start_dialogue = true
var current_dialogue: int = 0 

var huff_and_puff = preload(Utils.SCENE_HUFF_AND_PUFF)
var created_huff


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
	wolf.npc_target_reached.disconnect(_on_wolf_reached)


func _input(event):
	if event.is_action_pressed(Utils.ACTION_DEBUG):
		if created_huff: 
			created_huff.queue_free()
		var rand = Utils.ENUM_HUFF_TYPE.values()[randi() % Utils.ENUM_HUFF_TYPE.values().size()]
		
		created_huff = huff_and_puff.instantiate()
		add_child(created_huff)
		created_huff.new_huff(rand)
		created_huff.global_position = debug_target_location.global_position
		
		print("DEBUG: Creating huff type {0}".format([rand]))
