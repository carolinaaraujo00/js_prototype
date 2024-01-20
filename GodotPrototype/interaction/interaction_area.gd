class_name InteractionArea extends Area3D

var interact: Callable = func(): 
	pass

func _ready() -> void:
	assert(body_entered.connect(_on_body_entered) == OK)
	assert(body_exited.connect(_on_body_exited) == OK)


func _on_body_entered(_body) -> void:
	print("body entered")
	InteractionManager.register_area(self)


func _on_body_exited(_body) -> void:
	print("body exited")
	InteractionManager.unregister_area(self)
