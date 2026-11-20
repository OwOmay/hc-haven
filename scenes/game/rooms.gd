extends Node2D

signal revert


func _revert() -> void:
	GlobalVars.current_time = GlobalVars.current_time - GlobalVars.time_mod
	GlobalVars.cancel_move = true
	GlobalAudio.get_child(0).play()


func _change_room(_x: int, _y: int) -> void:
	position = -Vector2(GlobalVars.screen_coord) * Vector2(640, 480)


func _ready() -> void:
	GlobalVars.change_screen.connect(
		func(x: int, y: int) -> void:
			_change_room.call_deferred(x, y),
	)
	revert.connect(_revert)
