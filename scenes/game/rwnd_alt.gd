extends Node

var was_rewinding := false

func _process(delta: float) -> void:
	if (Input.is_action_pressed("rwnd") and GlobalVars.current_time > GlobalVars.unlocked_start) and not GlobalVars.cancel_move:
		GlobalVars.time_mod = -1
		was_rewinding = true
		if GlobalVars.current_time - GlobalVars.time_step * delta >= GlobalVars.unlocked_start:
			GlobalVars.current_time -= GlobalVars.time_step * delta
		else:
			GlobalVars.current_time = GlobalVars.unlocked_start
		if is_equal_approx(GlobalVars.current_time, GlobalVars.unlocked_start):
			GlobalAudio.get_child(0).play()
	elif was_rewinding:
		GlobalVars.time_mod = 0
		was_rewinding = false
