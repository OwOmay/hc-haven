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

var inventory = []

var temp_coyote := 0.0
var temp_buffer := 0.0
var has_stopped_jump := false
var can_change_screen := 0.0


func _transition_screen(x: int, y: int):
	GlobalVars.screen_coord.x += x
	GlobalVars.screen_coord.y += y

	if x == -1:
		position.x = 630
	if x == 1:
		position.x = 10

	if y == -1:
		position.y = 470
	if y == 1:
		position.y = 10

	can_change_screen = 0.1


func _ready():
	GlobalVars.change_screen.connect(_transition_screen)
	GlobalVars.player = self


func _process(_delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		GlobalVars.cancel_move = false


func _physics_process(delta: float) -> void:
	can_change_screen -= delta

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

	var dir := Vector2i.ZERO

	if position.x < 0:
		dir.x -= 1
	if position.x > 640:
		dir.x += 1
	if position.y < 0:
		dir.y -= 1
	if position.y > 480:
		dir.y += 1

	if dir.length_squared() != 0 and can_change_screen < 0.0:
		can_change_screen = false
		GlobalVars.change_screen.emit(dir.x, dir.y)
