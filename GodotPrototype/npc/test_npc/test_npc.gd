extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite3D = $Sprite3D

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	print("interacted!")
