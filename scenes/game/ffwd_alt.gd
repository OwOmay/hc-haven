extends Node

var was_forward := false


func _process(delta: float) -> void:
	if (
		(
			Input.is_action_pressed("ffwd")
			and GlobalVars.current_time < GlobalVars.unlocked_end - 0.01
		)
		and not GlobalVars.cancel_move
	):
		GlobalVars.time_mod = 1
		was_forward = true
		if GlobalVars.current_time + GlobalVars.time_step * delta <= GlobalVars.unlocked_end:
			GlobalVars.current_time += GlobalVars.time_step * delta
		else:
			GlobalVars.current_time = GlobalVars.unlocked_end
		if is_equal_approx(GlobalVars.current_time, GlobalVars.unlocked_end):
			GlobalAudio.get_child(0).play()
	elif was_forward:
		GlobalVars.time_mod = 0
		was_forward = false
