extends Node3D

@export var tilt_strength := 0.7
@export var max_tilt_degree := 20
@export var grab_force = 10
@export var release_force = 0.5
var grab:RigidBody3D


var current_tilt := Vector2.ZERO
var hold_distance : float = 0.8
func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		event as InputEventMouseButton
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					hold_distance += 0.07
				MOUSE_BUTTON_WHEEL_DOWN:
					hold_distance -= 0.07
@onready var camera:Camera3D = $Camera3D
@onready var grab_ray:RayCast3D = $"Camera3D/Grab Ray"
@onready var grab_target:Node3D = $"Camera3D/Grab Ray/Grab Target"


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		current_tilt.x = ((event.position.y / 480) - 0.5) * tilt_strength
		current_tilt.y = ((event.position.x / 640) - 0.5) * tilt_strength
		
		var max_tilt := deg_to_rad(max_tilt_degree)
		current_tilt.x = clamp(current_tilt.x, -max_tilt, max_tilt)
		current_tilt.y = clamp(current_tilt.y, -max_tilt, max_tilt)

func _process(_delta):
	rotation.z = current_tilt.x
	rotation.y = -current_tilt.y
func _physics_process(_delta):
	aim_ray_at_mouse()
	if Input.is_action_pressed("Grab"):
		if grab:
			if grab.get_colliding_bodies().is_empty() or (!grab.get_colliding_bodies().is_empty() and grab.get_colliding_bodies()[0] is RigidBody3D): grab.linear_velocity = grab_force * (grab_target.global_position - grab.global_position)
			else: release()
		elif Input.is_action_just_pressed("Grab") and grab_ray.is_colliding() and grab_ray.get_collider() is RigidBody3D:
			grab = grab_ray.get_collider()
			var mouse_pos = get_viewport().get_mouse_position()
			var ray_origin = camera.project_ray_origin(mouse_pos)
			
			aim_ray_at_mouse()
			await get_tree().create_timer(0.2).timeout
			if grab:
				grab.max_contacts_reported = 1
				grab.contact_monitor = true
	elif grab: release()
func release():
	grab.max_contacts_reported = 0
	grab.contact_monitor = false
	grab.linear_velocity *= release_force
	grab = null
	
func aim_ray_at_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	
	grab_ray.global_position = ray_origin
	grab_ray.target_position = grab_ray.to_local(ray_origin + ray_direction * 1000.0)

	grab_ray.force_raycast_update()
	
	grab_target.global_position = (ray_origin + ray_direction * hold_distance)
