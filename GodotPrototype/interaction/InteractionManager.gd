extends Node3D

signal clicked_ground

@onready var sprite_node := $SpriteNode
@onready var sprite := $SpriteNode/Sprite3D
@onready var label := $SpriteNode/Label
@onready var target_location_pointer := $TargetLocation

const RAY_LENGHT: int = 1000

var player: Node3D
var camera: Camera3D
var active_areas: Array = []
var is_interaction_blocked: bool = false
var interaction_sprite_y_offset: Vector3 = Vector3(0, 1.25, 0)
var interaction_label_y_offset: Vector3 = Vector3(0, .8, 0)
var current_interaction_area: InteractionArea

var space: PhysicsDirectSpaceState3D
var ray_query: PhysicsRayQueryParameters3D
var intersection_space_ray: Dictionary 


func _input(event) -> void:
	if get_tree().get_current_scene().scene_file_path != Utils.SCENE_MAIN_MENU:
		if Input.is_action_just_pressed(Utils.ACTION_LEFT_MOUSE):
			mouse_position_to_world_position(get_viewport().get_mouse_position())
		if Input.is_action_pressed(Utils.ACTION_INTERACT):
			if !is_interaction_blocked && active_areas.size() > 0 && active_areas[0].can_area_interact(): 
				is_interaction_blocked = true 
				sprite_node.visible = false
				
				current_interaction_area = active_areas[0]
				assert(current_interaction_area.interaction_finished.connect(_on_interaction_finished) == OK)
				print("DEBUG: Interacting with {0}, connected to signal, calling interact".format([str(current_interaction_area)]))
				await current_interaction_area.interact.call()


func mouse_position_to_world_position(mouse_position) -> void:
	var origin = player.camera.project_ray_origin(mouse_position)
	var target = origin + player.camera.project_ray_normal(mouse_position) * RAY_LENGHT
	
	ray_query = PhysicsRayQueryParameters3D.create(origin, target)
	ray_query.collide_with_areas = true
	
	intersection_space_ray = space.intersect_ray(ray_query)
	
	if intersection_space_ray:
		#if intersection_space_ray.collider.get_collision_layer_value(Utils.LAYER_NPC):
			#if !is_interaction_blocked && active_areas.size() > 0 && active_areas[0].can_area_interact(): 
				#is_interaction_blocked = true 
				#sprite_node.visible = false
				#
				#current_interaction_area = active_areas[0]
				#assert(current_interaction_area.interaction_finished.connect(_on_interaction_finished) == OK)
				#print("DEBUG: Interacting with {0}, connected to signal, calling interact".format([str(current_interaction_area)]))
				#await current_interaction_area.interact.call()
			#else:
				#print("clicked npc")
		
		if intersection_space_ray.collider.get_collision_layer_value(Utils.LAYER_WORLD):
			clicked_ground.emit(intersection_space_ray.position)
			player.navigation_agent.target_position = intersection_space_ray.position
			print("clicked ground")
		
		elif intersection_space_ray.collider.get_collision_layer_value(Utils.LAYER_EXERCISE_PROP):
			await intersection_space_ray.collider.interact.call()
			print("clicked exercise prop")


func register_player(player_to_register) -> void: 
	player = player_to_register
	print(player)
	print("DEBUG: Registered player {0}".format([str(player)]))


func register_area(area: InteractionArea) -> void:
	active_areas.push_back(area)
	print("DEBUG: Registered {0}".format([str(area)]))


func unregister_area(area: InteractionArea) -> void: 
	if active_areas.has(area): 
		# Double sanity check
		if area.is_connected(Utils.SIGNAL_INTERACTABLE_INTERACTION_FINISHED, _on_interaction_finished):
			area.interaction_finished.disconnect(_on_interaction_finished)
			if area == current_interaction_area: is_interaction_blocked = false
			print("DEBUG: Disconnected {0} signal interaction_finished on unregister".format([str(area)]))
		active_areas.erase(area)
		print("DEBUG: Unregistered {0}".format([str(area)]))


func _process(_delta) -> void:
	if active_areas.size() > 0 && !is_interaction_blocked: 
		active_areas.sort_custom(_sort_by_distance_to_player)
		
		if active_areas[0].can_area_interact():
			sprite_node.global_position = active_areas[0].global_position + interaction_sprite_y_offset 
			label.global_position = active_areas[0].global_position + interaction_label_y_offset 
			sprite_node.visible = true
	else:
		sprite_node.visible = false


func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea) -> bool:
	return player.global_position.distance_to(area1.global_position) < \
	 		player.global_position.distance_to(area2.global_position)


func _on_interaction_finished() -> void:
	is_interaction_blocked = false
	current_interaction_area.interaction_finished.disconnect(_on_interaction_finished)
	print("DEBUG: Interaction with {0} finished, disconnected signal".format([str(current_interaction_area)]))


func _physics_process(_delta):
	space = get_world_3d().direct_space_state
