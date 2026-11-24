extends Node

@export var required_key: String

func _physics_process(_delta: float) -> void:
	var bod = $Area2D.get_overlapping_bodies()
	if bod.size() > 0:
		if bod[0].inventory.has(required_key):
			bod[0].inventory.erase(required_key)
			queue_free()
