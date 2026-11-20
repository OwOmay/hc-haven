extends Label

signal show_text(txt: String)


func _show_text(txt: String) -> void:
	show()
	text = txt
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(hide)


func _ready() -> void:
	show_text.connect(_show_text)
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(272, 384), 0.2)
	tween.tween_property(self, "position", Vector2(282, 384), 0.2)
	tween.set_loops(1000000)
