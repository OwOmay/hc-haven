extends Node3D

@export var tilt_strength := 2
@export var max_tilt_degree := 15

var current_tilt := Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		current_tilt.x = ((event.position.y / 480) - 0.5) * tilt_strength
		current_tilt.y = ((event.position.x / 640) - 0.5) * tilt_strength
		
		var max_tilt := deg_to_rad(max_tilt_degree)
		current_tilt.x = clamp(current_tilt.x, -max_tilt, max_tilt)
		current_tilt.y = clamp(current_tilt.y, -max_tilt, max_tilt)

func _process(delta):
	rotation.z = current_tilt.x
	rotation.y = -current_tilt.y
# Cal
