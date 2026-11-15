extends Area3D

var mouseIsHovering: bool = false
var was_rewinding := false

func _on_mouse_entered() -> void:
	mouseIsHovering = true;

func _on_mouse_exited() -> void:
	mouseIsHovering = false;

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(_delta: float) -> void:
	if mouseIsHovering && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not is_zero_approx(GlobalVars.current_time):
		was_rewinding = true
		$"../../SubViewport/ColorRect".material.set_shader_parameter("roll_speed", -64)
		if GlobalVars.current_time - GlobalVars.time_step >= GlobalVars.start_time:
			GlobalVars.current_time -= GlobalVars.time_step
	elif was_rewinding:
		was_rewinding = false
		$"../../SubViewport/ColorRect".material.set_shader_parameter("roll_speed", 8)
	
