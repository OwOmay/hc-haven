extends Area3D

var mouseIsHovering: bool = false

func _on_mouse_entered() -> void:
	mouseIsHovering = true;

func _on_mouse_exited() -> void:
	mouseIsHovering = false;

func _ready() -> void:
	# Connect signals via code (or use the Node dock in the Godot editor)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta: float) -> void:
	if mouseIsHovering && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if GlobalVars.current_time + GlobalVars.time_step <= GlobalVars.end_time:
			GlobalVars.current_time += GlobalVars.time_step
		print("Moving Time Forward: " + str(GlobalVars.current_time))
