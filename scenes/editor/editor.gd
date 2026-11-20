extends Node2D

@onready var map: TileMapLayer = $TileMapLayerNow
@onready var fake: TileMapLayer = $TileMapLayerFake
@onready var past: TileMapLayer = $TileMapLayerPast
@onready var future: TileMapLayer = $TileMapLayerFuture

var level: Level
var current_screen := 0


func _load() -> void:
	if EditorData.current_game:
		level = EditorData.current_game
		for screen in level.screens.size():
			past.tile_map_data = level.screens[screen].tilemap
			var cells := past.get_used_cells_by_id(0, Vector2i(0, 0))
			cells.append_array(past.get_used_cells_by_id(0, Vector2i(0, 2)))
			cells.append_array(past.get_used_cells_by_id(0, Vector2i(1, 2)))
			cells.append_array(past.get_used_cells_by_id(0, Vector2i(2, 2)))
			for cell in cells:
				future.set_cell(cell, 0, Vector2i(0, 0))
			level.screens[screen].tilemap = future.tile_map_data

			past.clear()
			future.clear()
	else:
		level = Level.new()
		level.screens.append(Screen.new())


func _ready() -> void:
	_load()
	_update_number_of_screens()
	_on_current_screen_value_changed(0)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("editor_ui"):
		$Control.visible = not $Control.visible

	if not $Control.visible:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			map.set_cell(map.local_to_map(get_global_mouse_position()), 0, Vector2i(0, 0))
			level.screens[current_screen].tilemap = map.tile_map_data
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			map.erase_cell(map.local_to_map(get_global_mouse_position()))
			level.screens[current_screen].tilemap = map.tile_map_data

	_gen_fake()


func _gen_fake():
	if current_screen > 0:
		past.tile_map_data = level.screens[current_screen - 1].tilemap
	else:
		past.tile_map_data = PackedByteArray()
	if current_screen < level.screens.size() - 1:
		future.tile_map_data = level.screens[current_screen + 1].tilemap
	else:
		future.tile_map_data = PackedByteArray()

	for x in 20:
		for y in 15:
			fake.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))

			var cell = map.get_cell_tile_data(Vector2i(x, y))
			var past_cell = past.get_cell_tile_data(Vector2i(x, y))
			var future_cell = future.get_cell_tile_data(Vector2i(x, y))
			match [
				cell != null,
				past_cell != null,
				future_cell != null,
				current_screen > 0,
				current_screen < level.screens.size() - 1,
			]:
				[true, false, false, false, false], [true, false, true, false, true], [
					true,
					true,
					false,
					true,
					false,
				], [true, true, true, true, true]:
					# solid black
					fake.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
				[false, true, false, true, false], [false, true, false, true, true]:
					# striped red
					fake.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
				[false, false, true, false, true], [false, false, true, true, true]:
					# striped blue
					fake.set_cell(Vector2i(x, y), 0, Vector2i(1, 1))
				[false, true, true, true, true]:
					# striped green
					fake.set_cell(Vector2i(x, y), 0, Vector2i(2, 1))
				[true, false, false, true, false], [true, false, true, true, true]:
					# solid red
					fake.set_cell(Vector2i(x, y), 0, Vector2i(0, 2))
				[true, false, false, false, true], [true, true, false, true, true]:
					# solid blue
					fake.set_cell(Vector2i(x, y), 0, Vector2i(1, 2))
				[true, false, false, true, true]:
					# solid green
					fake.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))


func _on_current_screen_value_changed(value: float) -> void:
	current_screen = int(value)

	map.tile_map_data = level.screens[current_screen].tilemap

	$Control/Panel/CenterContainer/VBoxContainer/HBoxContainer/MinTime.set_value_no_signal(
		level.screens[current_screen].min_time
	)
	$Control/Panel/CenterContainer/VBoxContainer/HBoxContainer2/MaxTime.set_value_no_signal(
		level.screens[current_screen].max_time
	)


func _update_number_of_screens() -> void:
	$Control/Panel/CenterContainer/VBoxContainer/HBoxContainer3/CurrentScreen.max_value = level \
			.screens \
			.size() - 1
	$Control/Panel/CenterContainer/VBoxContainer/HBoxContainer3/CurrentScreen.tick_count = level \
			.screens \
			.size()


func _on_add_screen_pressed() -> void:
	var new_screen := level.screens[current_screen].duplicate(true)
	level.screens.insert(current_screen + 1, new_screen)
	_update_number_of_screens()
	$Control/Panel/CenterContainer/VBoxContainer/HBoxContainer3/CurrentScreen.value += 1


func _on_remove_screen_pressed() -> void:
	level.screens.remove_at(current_screen)
	_update_number_of_screens()
	$Control/Panel/CenterContainer/VBoxContainer/HBoxContainer3/CurrentScreen.value = clampf(
		$Control/Panel/CenterContainer/VBoxContainer/HBoxContainer3/CurrentScreen.value,
		0,
		level.screens.size() - 1,
	)


func _on_min_time_value_changed(value: float) -> void:
	level.screens[current_screen].min_time = value


func _on_max_time_value_changed(value: float) -> void:
	level.screens[current_screen].max_time = value


func _gen_level() -> Level:
	var temp_level := Level.new()
	var old_current := current_screen
	for screen in level.screens.size():
		current_screen = screen
		map.tile_map_data = level.screens[screen].tilemap
		_gen_fake()
		var temp_screen := Screen.new()
		temp_screen.min_time = level.screens[screen].min_time
		temp_screen.max_time = level.screens[screen].max_time
		temp_screen.tilemap = fake.tile_map_data
		temp_level.screens.append(temp_screen)
	current_screen = old_current
	return temp_level


func _on_playtest_pressed() -> void:
	EditorData.current_game = _gen_level()
	get_tree().change_scene_to_file("res://scenes/editor/playtest.tscn")


func _on_save_pressed() -> void:
	$Save.popup_centered()


func _on_load_pressed() -> void:
	$Load.popup_centered()


func _on_save_file_selected(path: String) -> void:
	var temp_level := _gen_level()
	ResourceSaver.save(temp_level, path)


func _on_load_file_selected(path: String) -> void:
	var temp_level = ResourceLoader.load(path)
	if temp_level and temp_level is Level:
		EditorData.current_game = temp_level
		_load()
		_update_number_of_screens()
