extends Control


func _ready() -> void:
	$VBoxContainer/Play.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game_view.tscn")


func _on_editor_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/editor/editor.tscn")
