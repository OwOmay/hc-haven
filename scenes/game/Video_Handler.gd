extends VideoStreamPlayer


func _ready() -> void:
	finished.connect(hide)
