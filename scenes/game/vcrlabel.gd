extends Label

func _process(_delta: float) -> void:
	text = str(int(floorf(GlobalVars.current_time / 60.0))) + ":" + str(int(floorf(GlobalVars.current_time)) % 60).pad_zeros(2) + "/" + str(int(floorf(GlobalVars.end_time / 60.0))) + ":" + str(int(floorf(GlobalVars.end_time)) % 60).pad_zeros(2)
