extends TileMapLayer

@export var min_time := 0.0
@export var max_time := 0.0

var previous_shown := false

func _revert() -> void:
	if previous_shown:
		_enable()
	else:
		_disable()

func _ready() -> void:
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

func _process(_delta: float) -> void:
	previous_shown = visible
	if floorf(GlobalVars.current_time) <= max_time and ceilf(GlobalVars.current_time) >= min_time:
		if get_index() > 0:
			if get_parent().get_child(get_index() - 1).visible:
				return
		_enable()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		var col = CircleShape2D.new()
		col.radius = 14
		query.shape = col
		query.transform = GlobalVars.player.global_transform
		query.collision_mask = 1
		var results = space_state.intersect_shape(query)
		var cell = get_cell_tile_data(local_to_map(to_local(GlobalVars.player.global_position)))
		if results.size() > 0:
			get_parent().get_parent().revert.emit()
		elif cell:
			if cell.get_collision_polygons_count(0) > 0:
				get_parent().get_parent().revert.emit()
	else:
		_disable()
