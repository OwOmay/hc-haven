extends VideoStreamPlayer

func _ready() -> void:
	WorldStateHandler.gameStateMachine.on_transition_to_String("Intro_Video", func(): print("Playing Intro Video"))
	finished.connect(WorldStateHandler.gameStateMachine.transition_to_String.bind("In_Game"))
