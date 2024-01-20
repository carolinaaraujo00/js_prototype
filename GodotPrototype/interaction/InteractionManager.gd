extends Node

@onready var player := get_tree().get_first_node_in_group(Utils.GROUP_PLAYER)
@onready var sprite := $Sprite3D

var active_areas: Array = []
var can_interact: bool = true
var interaction_sprite_y_offset: int = 36

func register_area(area: InteractionArea) -> void:
	print("registered")
	active_areas.push_back(area)


func unregister_area(area: InteractionArea) -> void: 
	if active_areas.has(area): 
		active_areas.erase(area)


func _process(_delta) -> void:
	if active_areas.size() > 0 && can_interact: 
		active_areas.sort_custom(_sort_by_distance_to_player)
		sprite.global_position = active_areas[0].global_position
		sprite.global_position.y -= interaction_sprite_y_offset 
		sprite.show()
		print("sprite show")
	else:
		sprite.hide()


func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea) -> bool:
	return player.global_position.distance_to(area1.global_position) < \
			player.global_position.distance_to(area2.global_position)


func _input(event):
	if event.is_action_pressed("action_left_mouse") && can_interact:
		if active_areas.size() > 0: 
			can_interact = false 
			sprite.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
