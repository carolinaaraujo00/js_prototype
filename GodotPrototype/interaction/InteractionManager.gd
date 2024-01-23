extends Node

@onready var player := get_tree().get_first_node_in_group(Utils.GROUP_PLAYER)
@onready var sprite_node := $SpriteNode
@onready var sprite := $SpriteNode/Sprite3D
@onready var label := $SpriteNode/Label

var active_areas: Array = []
var can_interact: bool = true
var interaction_sprite_y_offset: Vector3 = Vector3(0, 1.25, 0)
var interaction_label_y_offset: Vector3 = Vector3(0, .8, 0)

var current_interaction_area: InteractionArea


func register_area(area: InteractionArea) -> void:
	print("DEBUG: Registering {0}".format([str(area)]))
	active_areas.push_back(area)


func unregister_area(area: InteractionArea) -> void: 
	if active_areas.has(area): 
		active_areas.erase(area)
		print("DEBUG: Unregistering {0}".format([str(area)]))


func _process(_delta) -> void:
	if active_areas.size() > 0 && can_interact: 
		active_areas.sort_custom(_sort_by_distance_to_player)
		
		sprite_node.global_position = active_areas[0].global_position + interaction_sprite_y_offset 
		label.global_position = active_areas[0].global_position + interaction_label_y_offset 
		sprite_node.visible = true
	else:
		sprite_node.visible = false


func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea) -> bool:
	return player.global_position.distance_to(area1.global_position) < \
			player.global_position.distance_to(area2.global_position)


func _input(event) -> void:
	if event.is_action_pressed(Utils.ACTION_INTERACT) && can_interact:
		if active_areas.size() > 0: 
			can_interact = false 
			sprite_node.visible = false
			
			current_interaction_area = active_areas[0]
			assert(current_interaction_area.interaction_finished.connect(_on_interaction_finished) == OK)
			print("DEBUG: Interacting with {0}, connected to signal, calling interact".format([str(current_interaction_area)]))
			await current_interaction_area.interact.call()


func _on_interaction_finished() -> void:
	print("DEBUG: Interaction with {0} finished, disconnecting signal".format([str(current_interaction_area)]))
	can_interact = true
	current_interaction_area.interaction_finished.disconnect(_on_interaction_finished)
