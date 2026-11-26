extends Area3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var entry_point: Marker3D = $EntryPoint
@onready var insert_sfx: AudioStreamPlayer = $InsertSFX


var _has_switched: bool = false
var triggered := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered) # Replace with function body.




func _on_body_entered(body: Node3D) -> void:
	if _has_switched:
		return
		
		
	if body.name == "RigidBody3D2":
		print("Level Selected!")
		
		_has_switched = true
		
		body.freeze = true
		insert_sfx.play()
		await get_tree().create_timer(.1).timeout
		body.reparent(self, true)
		var tweens := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tweens.tween_property(body, "global_transform", entry_point.global_transform, .75)
		anim_player.play("Insert tape")
		#body.hide()
	
		
	
		await get_tree().create_timer(2).timeout		
		
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/game_view.tscn")
		print("selected Anim")
