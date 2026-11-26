extends Node2D

signal revert

func _revert() -> void:
	GlobalVars.current_time = GlobalVars.current_time - GlobalVars.time_mod
	GlobalVars.cancel_move = true
	GlobalAudio.get_node("Transition").play()

func _change_room() -> void:
	position = -GlobalVars.screen_coord * Vector2(640, 480)

func _ready() -> void:
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Left", call_deferred.bind("_change_room"))
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Right", call_deferred.bind("_change_room"))
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Up", call_deferred.bind("_change_room"))
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Down", call_deferred.bind("_change_room"))
	
	revert.connect(_revert)
	
	#for i in GlobalVars.game_screens_width:
		#for j in GlobalVars.game_screens_height:
			#Room.new(i, j, 5, [0, 50, 100, 150, 200])
#
#class Room extends Node:
	#var x: int
	#var y: int
	#var personal_tile_map: TileMapLayer
	#var state_machine: WorldStateHandler.stateMachine
	#var time_states: Array[WorldStateHandler.State]
	#var state_transition_times: Array[float]
	#
	#func _init(room_x: int, room_y: int, different_time_states: int, state_trainsition_times: Array[float]):
		#x = room_x
		#y = room_y
		#var temp_location = find_child(str(x)+"_"+str(y))
		#var last_set_time_state: int = 0
		#
		#if (temp_location != null):
			#personal_tile_map = temp_location.get_child(0)
			#if (personal_tile_map != null):
				#personal_tile_map.show()
				#personal_tile_map.collision_enabled = true
		#
		#
		#for i in different_time_states:
			#time_states.push_back(WorldStateHandler.State.new("Time_"+str(i)))
			#
		#state_machine = WorldStateHandler.stateMachine.new(time_states)
	#
	#func _process(delta: float) -> void:
		#for i in state_transition_times.size()-1:
			#if GlobalVars.current_time > state_transition_times[i] && GlobalVars.current_time < state_transition_times[i+1]:
				#if self.last_set_time_state != i:
					#self.last_set_time_state = i
					#self._updateSelfToTime(i)
		#
	#func _updateSelfToTime(time_step: int):
		#var tempTileMap = find_child(str(x)+"_"+str(y)).get_child(time_step)
		#
		#if(tempTileMap != null):
			#personal_tile_map.hide()
			#personal_tile_map.collision_enabled = false
			#personal_tile_map = tempTileMap
			#
		#personal_tile_map.show()
		#personal_tile_map.collision_enabled = true
		
