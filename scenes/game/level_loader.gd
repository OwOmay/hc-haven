extends Node2D

@export var level: Level

func _load_level() -> void:
	if level:
		for screen in level.screens:
			var tilemap := TileMapLayer.new()
			tilemap.set_script(preload("res://scenes/game/timing.gd"))
			tilemap.min_time = screen.min_time
			tilemap.max_time = screen.max_time
			tilemap.tile_map_data = screen.tilemap
			tilemap.tile_set = preload("res://assets/tiles/tiles.tres")
			tilemap.visible = false
			tilemap.collision_enabled = false
			add_child(tilemap)

func _ready() -> void:
	_load_level()
