extends Node2D

var is_started := false


func _ready() -> void:
	$Game/Player.process_mode = Node.PROCESS_MODE_DISABLED
	$"Game/Rooms/0_0".level = EditorData.current_game
	$"Game/Rooms/0_0".load_level()


func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not is_started:
		is_started = true
		$Game/Player.process_mode = Node.PROCESS_MODE_INHERIT
		$Game/Player.position = get_global_mouse_position()
	if Input.is_action_just_pressed("end_playtest"):
		get_tree().change_scene_to_file("res://scenes/editor/editor.tscn")
