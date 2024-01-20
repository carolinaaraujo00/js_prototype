class_name TargetLocation extends Node3D

@onready var animation_player := $AnimationPlayer
@onready var mesh := $MeshInstance3D
@onready var player: CharacterBody3D =  $"../CharacterBody3D"

var material: Material
var ground_multiplier: float = 0.02
var starting_radius: float = 0.01 

func _ready() -> void: 
	material = mesh.get_active_material(0)
	material.set_shader_parameter("radius", starting_radius)
	assert(player.clicked_ground.connect(_on_ground_click) == OK)


func _on_ground_click(click_position: Vector3) -> void: 
	if !visible: 
		visible = !visible
	global_position = click_position + Vector3.UP * ground_multiplier
	animation_player.play(Utils.ANIMATION_GROUND_TARGET_LOCATION)
