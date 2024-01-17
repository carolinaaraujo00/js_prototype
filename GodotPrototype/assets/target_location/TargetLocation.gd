extends Node3D

@onready var animation_player := $AnimationPlayer
@onready var mesh := $MeshInstance3D

var material: Material
var ground_multiplier: float = 0.02
var starting_radius: float = 0.01 

func _ready() -> void: 
	material = mesh.get_active_material(0)
	material.set_shader_parameter("radius", starting_radius)

func click(click_position: Vector3) -> void: 
	global_position = click_position + Vector3.UP * ground_multiplier
	animation_player.play(Utils.ANIMATION_GROUND_TARGET_LOCATION)
