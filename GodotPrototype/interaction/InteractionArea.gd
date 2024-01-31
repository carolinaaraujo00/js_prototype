class_name InteractionArea extends Area3D

signal interaction_finished

var can_interact: bool = false

var interact: Callable = func(): 
	pass


func _set_can_interact(new_bool: bool) -> void: 
	can_interact = new_bool 


func can_area_interact() -> bool: 
	return can_interact


func _ready() -> void:
	assert(body_entered.connect(_on_body_entered) == OK)
	assert(body_exited.connect(_on_body_exited) == OK)


func _on_body_entered(_body) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(_body) -> void:
	InteractionManager.unregister_area(self)


func _on_interaction_finished() -> void: 
	print("DEBUG: {0} emitting interaction finished signal".format([str(self)]))
	emit_signal(Utils.SIGNAL_INTERACTABLE_INTERACTION_FINISHED)
