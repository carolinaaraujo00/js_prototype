class_name Player extends CharacterBody3D

const SPEED: float = 300

var target_position : Vector3
var direction: Vector3

@onready var navigation_agent := $NavigationAgent3D
@onready var camera := $Camera3D

var can_move: bool = true

func _ready() -> void: 
	InteractionManager.register_player(self)


func set_position_and_block(new_target: Vector3, block: bool) -> void:
	navigation_agent.target_position = new_target
	can_move = block


func set_block_movement(is_blocked: bool) -> void: 
	print("set block movement: {0} to {1}".format([can_move, is_blocked]))
	can_move = is_blocked


func move_to_point(delta) -> void:
	direction = global_position.direction_to(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * SPEED * delta
	
	move_and_slide()


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	move_to_point(delta)
