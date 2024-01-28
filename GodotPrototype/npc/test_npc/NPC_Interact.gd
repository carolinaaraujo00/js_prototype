extends Node3D

@onready var interaction_area: InteractionArea = $NPC_NavigationAgent/InteractionArea
@onready var navigation_agent: CharacterBody3D = $NPC_NavigationAgent
@onready var sprite: Sprite3D = $NPC_NavigationAgent/Sprite3D

var array_target_positions: Array[Vector3] = []
var target_position: Vector3 

func set_area_can_interact(can_interact: bool) -> void: 
	interaction_area._set_can_interact(can_interact)

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
	for child in self.get_children():
		if child.is_in_group(Utils.GROUP_TARGET_POSITION): 
			array_target_positions.push_back(child.global_position)


func set_next_target() -> void: 
	if array_target_positions.size() > 0:
		target_position = array_target_positions.pop_front()

		navigation_agent.set_target_position(target_position)
		assert(navigation_agent.npc_target_reached.connect(_on_navigation_finished) == OK)
		print("DEBUG: NPC {0} target position set at {1}, signal on_navigation_finished connected".format([self, target_position]))
	else: 
		print("DEBUG: NPC {0} no other target positions".format([self]))


func _on_interact() -> void:
	pass


func _on_navigation_finished() -> void: 
	navigation_agent.npc_target_reached.disconnect(_on_navigation_finished)
	print("DEBUG: NPC {0} target reached {1}, finishing interaction".format([self, target_position]))
	interaction_area._on_interaction_finished()
