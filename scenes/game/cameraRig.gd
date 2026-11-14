extends Camera3D
@export var tilt_strength := 0.005
@export var max_tilt_degree := 10

var current_tilt := Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		current_tilt.x -= event.relative.y * tilt_strength
		current_tilt.y -= event.relative.x * tilt_strength
		
		var max_tilt := deg_to_rad(max_tilt_degree)
		current_tilt.x = clamp(current_tilt.x, -max_tilt, max_tilt)
		current_tilt.y = clamp(current_tilt.y, -max_tilt, max_tilt)

func _process(delta):
	rotation.x = current_tilt.x
	rotation.y = current_tilt.y
# Cal
