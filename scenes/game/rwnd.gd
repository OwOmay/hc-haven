extends Area3D

var mouseIsHovering: bool = false
var was_rewinding := false

func _on_mouse_entered() -> void:
	mouseIsHovering = true

func _on_mouse_exited() -> void:
	mouseIsHovering = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta: float) -> void:
	if (mouseIsHovering && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and GlobalVars.current_time > GlobalVars.unlocked_start) and not GlobalVars.cancel_move:
		GlobalVars.time_mod = -1
		was_rewinding = true
		$"../../SubViewport/ColorRect".material.set_shader_parameter("roll_speed", -64)
		if GlobalVars.current_time - GlobalVars.time_step * delta >= GlobalVars.unlocked_start:
			GlobalVars.current_time -= GlobalVars.time_step * delta
		else:
			GlobalVars.current_time = GlobalVars.unlocked_start
		if is_equal_approx(GlobalVars.current_time, GlobalVars.unlocked_start):
			GlobalAudio.get_child(0).play()
	elif was_rewinding:
		GlobalVars.time_mod = 0
		was_rewinding = false
		$"../../SubViewport/ColorRect".material.set_shader_parameter("roll_speed", 8)
	
