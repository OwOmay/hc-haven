@tool
extends Node

@export var tilemap: TileMapLayer

@export_tool_button("generate rooms")
var gen = generate_rooms

func generate_rooms():
	for x in 5:
		for y in 5:
			var node := Node2D.new()
			node.name = str(x) + "_" + str(y)
			node.position = Vector2(640 * x, 480 * y)
			$"..".add_child(node)
			node.owner = get_tree().edited_scene_root
			var tm := tilemap.duplicate()
			node.add_child(tm)
			tm.owner = get_tree().edited_scene_root
