extends Node

@export var item_name: String
@export var id: String
@export var img: Texture2D

func _physics_process(_delta: float) -> void:
	var bod = $Area2D.get_overlapping_bodies()
	if bod.size() > 0:
		print(item_name + " get")
		bod[0].inventory.append(id)
		queue_free()
