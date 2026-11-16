extends Control

func _ready() -> void:
	WorldStateHandler.gameStateMachine.add_state("Menu")
	WorldStateHandler.gameStateMachine.add_state("In_Game")
	WorldStateHandler.gameStateMachine.transition_to_String("Menu")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		_on_button_pressed()

func _on_button_pressed() -> void:
	WorldStateHandler.gameStateMachine.transition_to_String("Intro_Video")
	get_tree().change_scene_to_file("res://scenes/game/game_view.tscn")
