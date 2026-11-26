extends TileMapLayer

@export var trigger_shake := true
static var last_shake_time := 0
@export var min_time := 0.0
@export var max_time := 0.0
@export var camera3D: Camera3D

var cameraShakeNoise : FastNoiseLite




var previous_shown := false

func _revert() -> void:
	if previous_shown:
		_enable()
	else:
		_disable()

func _ready() -> void:
	if not camera3D:
		camera3D = $"../../../../../CameraRig/Camera3D"
	cameraShakeNoise = FastNoiseLite.new()
	cameraShakeNoise.frequency = 0.05
	get_parent().get_parent().revert.connect(_revert)

func _enable() -> void:
	show()
	collision_enabled = true
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_INHERIT

func _disable() -> void:
	hide()
	collision_enabled = false
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED


func StartCameraShake(intensity: float):
	var cameraOffset = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera3D.h_offset = cameraOffset
	camera3D.v_offset = cameraOffset
	
	

func _process(_delta: float) -> void:
	previous_shown = visible
	if floorf(GlobalVars.current_time) <= max_time and ceilf(GlobalVars.current_time) >= min_time:
		if get_index() > 0:
			if get_parent().get_child(get_index() - 1).visible:
				return
		
		if not visible:
			_enable()
			var now := Time.get_ticks_msec()
			if trigger_shake and not get_used_cells().is_empty() and now - last_shake_time > 350:
				last_shake_time = now
				var camera_tween = get_tree().create_tween()
				camera_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
				camera_tween.tween_method(StartCameraShake, 0.04, 0.0, 0.20)
			
		var space_state := get_world_2d().direct_space_state
		var query := PhysicsShapeQueryParameters2D.new()
		var col := CircleShape2D.new()
		col.radius = 14
		query.shape = col
		query.transform = GlobalVars.player.global_transform
		query.collision_mask = 1
		var results = space_state.intersect_shape(query)
		var cells := [
			get_cell_tile_data(local_to_map(to_local(GlobalVars.player.global_position) + Vector2(-6, 0))),
			get_cell_tile_data(local_to_map(to_local(GlobalVars.player.global_position) + Vector2(6, 0))),
			get_cell_tile_data(local_to_map(to_local(GlobalVars.player.global_position) + Vector2(0, -6))),
			get_cell_tile_data(local_to_map(to_local(GlobalVars.player.global_position) + Vector2(0, 6)))
		]
		if results.size() > 0:
			get_parent().get_parent().revert.emit()
		else:
			for cell in cells:
				if cell:
					if cell.get_collision_polygons_count(0) > 0:
						get_parent().get_parent().revert.emit()
						break
	else:
		if visible:
			_disable()
