class_name Player extends CharacterBody3D

const SPEED: float = 300

var target_position : Vector3
var direction: Vector3

@onready var navigation_agent := $NavigationAgent3D
@onready var camera := $Camera3D

var can_move: bool = true

func _ready() -> void: 
	InteractionManager.register_player(self)


func _input(_event) -> void: 
	pass
	#if Input.is_action_just_pressed(Utils.ACTION_LEFT_MOUSE) && can_move:
		#_mouse_position_to_world_position(get_viewport().get_mouse_position())


func block_movement(is_blocked: bool) -> void: 
	can_move = is_blocked


func move_to_point(delta) -> void:
	direction = global_position.direction_to(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * SPEED * delta
	
	move_and_slide()


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	move_to_point(delta)


#func _mouse_position_to_world_position(mouse_position) -> void:
	#var origin = camera.project_ray_origin(mouse_position)
	#var target = origin + camera.project_ray_normal(mouse_position) * RAY_LENGHT
	#
	#ray_query = PhysicsRayQueryParameters3D.create(origin, target, Utils.MASK_WORLD)
	#ray_query.collide_with_areas = true
	#
	#intersection_space_ray = space.intersect_ray(ray_query)
	#
	#if intersection_space_ray:
		#clicked_ground.emit(intersection_space_ray.position)
		#navigation_agent.target_position = intersection_space_ray.position


