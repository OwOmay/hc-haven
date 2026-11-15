extends VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WorldStateHandler.gameStateMachine.add_state("Intro_Video")
	WorldStateHandler.gameStateMachine.on_transition_to_String("Intro_Video", func(): print("Playing Intro Video"))
	finished.connect(WorldStateHandler.gameStateMachine.transition_to_String.bind("In_Game"))
