class_name Player extends CharacterBody3D

const RAY_LENGHT: int = 1000
const SPEED: float = 300

var target_position : Vector3
var direction: Vector3
var space: PhysicsDirectSpaceState3D
var ray_query: PhysicsRayQueryParameters3D
var intersection_space_ray: Dictionary 

@onready var navigation_agent := $NavigationAgent3D
@onready var camera := $Camera3D
@onready var target_location := $"../TargetLocation"


func _input(_event) -> void: 
	if Input.is_action_just_pressed(Utils.ACTION_LEFT_MOUSE):
		_mouse_position_to_world_position(get_viewport().get_mouse_position())


func _mouse_position_to_world_position(mouse_position) -> void:
	var origin = camera.project_ray_origin(mouse_position)
	var target = origin + camera.project_ray_normal(mouse_position) * RAY_LENGHT
	
	ray_query = PhysicsRayQueryParameters3D.create(origin, target, Utils.GROUND_MASK)
	ray_query.collide_with_areas = true
	
	intersection_space_ray = space.intersect_ray(ray_query)
	
	if intersection_space_ray:
		target_location.click(intersection_space_ray.position)
		navigation_agent.target_position = intersection_space_ray.position


func _move_to_point(delta) -> void:
	direction = global_position.direction_to(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * SPEED * delta
	
	move_and_slide()


func _physics_process(delta):
	space = get_world_3d().direct_space_state
	
	if navigation_agent.is_navigation_finished():
		return
	
	_move_to_point(delta)
