extends CharacterBody2D

@export_group("Ground Movement")
@export var acceleration := 80.0
@export var max_speed := 300.0
@export var decceleration := 140.0
@export_group("Jumping")
@export var up_gravity := 1.0
@export var down_gravity := 1.5
@export var jump_power := -450.0
@export_group("Air Movement")
@export var air_acceleration := 60.0
@export var air_decceleration := 60.0
@export_group("Timings")
@export var coyote_time := 0.2
@export var buffer_time := 0.05

var temp_coyote := 0.0
var temp_buffer := 0.0
var has_stopped_jump := false

func _transitionScreen(x, y):
	GlobalVars.screen_coord.x += x
	GlobalVars.screen_coord.y += y
	
	if GlobalVars.screen_coord.x > GlobalVars.game_screens_width:
		GlobalVars.screen_coord.x = 0
	elif GlobalVars.screen_coord.x < 0:
		GlobalVars.screen_coord.x = GlobalVars.game_screens_width
		
	if GlobalVars.screen_coord.y > GlobalVars.game_screens_height:
		GlobalVars.screen_coord.y = 0
	elif GlobalVars.screen_coord.y < 0:
		GlobalVars.screen_coord.y = GlobalVars.game_screens_height
	
	if x < 0:
		position.x = 639
	elif x > 0:
		position.x = 1
	
	if y < 0:
		position.y = 479
	elif y > 0:
		position.y = 1
		
	print("Transitioned screens by: " + str(x) + ", " + str(y) + " to: " + str(GlobalVars.screen_coord.x) + ", " + str(GlobalVars.screen_coord.y))

func _ready():
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Left", _transitionScreen.bind(-1, 0))
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Right", _transitionScreen.bind(1, 0))
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Up", _transitionScreen.bind(0, -1))
	WorldStateHandler.gameStateMachine.on_transition_to_String("Screen_Change_Down", _transitionScreen.bind(0, 1))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		temp_coyote -= delta
		if velocity.y < 0:
			velocity += get_gravity() * delta * up_gravity
		else:
			velocity += get_gravity() * delta * down_gravity
	
	temp_buffer -= delta
	
	if is_on_floor():
		temp_coyote = coyote_time
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or temp_coyote > 0:
			temp_coyote = 0
			velocity.y = jump_power
			has_stopped_jump = false
		else:
			temp_buffer = buffer_time
	
	if (is_on_floor() or temp_coyote > 0) and temp_buffer > 0:
		velocity.y = jump_power
		has_stopped_jump = false
	
	if Input.is_action_just_released("jump") and not has_stopped_jump and velocity.y < 0:
		velocity.y -= velocity.y * 0.9
		has_stopped_jump = true

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration)

	move_and_slide()
	
	
	
	if position.x < 0:
		WorldStateHandler.gameStateMachine.transition_to_String("Screen_Change_Left").transition_to_String("In_Game")
	if position.x > 640:
		WorldStateHandler.gameStateMachine.transition_to_String("Screen_Change_Right").transition_to_String("In_Game")
	if position.y < 0:
		WorldStateHandler.gameStateMachine.transition_to_String("Screen_Change_Up").transition_to_String("In_Game")
	if position.y > 480:
		WorldStateHandler.gameStateMachine.transition_to_String("Screen_Change_Down").transition_to_String("In_Game")


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("i'm corrupted oh no")
