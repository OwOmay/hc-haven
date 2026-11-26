extends Area3D

var was_forward := false
var mouseIsHovering: bool = false

func _on_mouse_entered() -> void:
	mouseIsHovering = true

func _on_mouse_exited() -> void:
	mouseIsHovering = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta: float) -> void:
	if (((mouseIsHovering && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) or Input.is_action_pressed("ffwd")) and GlobalVars.current_time < GlobalVars.unlocked_end - 0.01) and not GlobalVars.cancel_move:
		GlobalVars.time_mod = 1
		was_forward = true
		#$"../vcr/SubViewport/ColorRect".material.set_shader_parameter("roll_speed", 64)
		if GlobalVars.current_time + GlobalVars.time_step * delta <= GlobalVars.unlocked_end:
			GlobalVars.current_time += GlobalVars.time_step * delta
		else:
			GlobalVars.current_time = GlobalVars.unlocked_end
		if is_equal_approx(GlobalVars.current_time, GlobalVars.unlocked_end):
			GlobalAudio.get_node("FFWD").play()
	elif was_forward:
		GlobalVars.time_mod = 0
		was_forward = false
		#$"../vcr/SubViewport/ColorRect".material.set_shader_parameter("roll_speed", 8)
