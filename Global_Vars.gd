extends Node

var time_mod := 0
var current_time := 150.0
var time_step := 30.0
var unlocked_start := 120.0
var start_time := 0.0
var unlocked_end := 180.0
var end_time := 562.0
var game_screens_width: int = 5
var game_screens_height: int = 5

var screen_coord := Vector2.ZERO

var player: Node
