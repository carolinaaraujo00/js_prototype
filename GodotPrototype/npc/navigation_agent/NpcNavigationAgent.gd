class_name NpcNavigationAgent extends CharacterBody3D

signal npc_target_reached 

@onready var navigation_agent := $NavigationAgent3D

const SPEED = 200

var target_position: Vector3
var direction: Vector3 
var reached_target: bool = false

func set_target_position(new_position: Vector3) -> void:
	reached_target = false 
	target_position = new_position
	navigation_agent.target_position = target_position


func _move_to_point(delta) -> void:
	direction = global_position.direction_to(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * SPEED * delta
	
	move_and_slide()


func _physics_process(delta):
	if navigation_agent.is_navigation_finished() && !reached_target && target_position:
		print("DEBUG: NPC {0} finished navigation, emitting reached signal".format([self]))
		reached_target = true 
		emit_signal(Utils.SIGNAL_NPC_REACHED_TARGET)
		return
	
	_move_to_point(delta)
