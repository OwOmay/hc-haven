extends Node
@onready var progress_bar: ColorRect = $"../../../../MeshInstance3D4/SubViewport2/TimeLineUI2/ProgressBar"
@onready var play_head: ColorRect = $"../../../../MeshInstance3D4/SubViewport2/TimeLineUI2/PlayHead"
@onready var timeline_track: ColorRect = $"../../../../MeshInstance3D4/SubViewport2/TimeLineUI2/TimelineTrack"

var progress: float = 0.0
var time_range: float = 0.0
var playhead_position: float = 0.0

func _process(_delta: float) -> void:
	time_range = GlobalVars.unlocked_end - GlobalVars.unlocked_start
	
	if time_range <= 0.0:
		progress = 0.0
		playhead_position = 0.0
		progress_bar.size.x = 0.0
		play_head.position.x = timeline_track.position.x 
		return
		
	progress = (GlobalVars.current_time - GlobalVars.unlocked_start) / time_range
	progress = clampf(progress, 0.0, 1.0)
	playhead_position = progress * timeline_track.size.x
	progress_bar.position.x = timeline_track.position.x
	progress_bar.size.x = playhead_position
	play_head.position.x = timeline_track.position.x + playhead_position
