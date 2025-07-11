extends Camera3D
@export_group("Camera")
@export_range(-90.0, 90.0, 1.0, "Degrees") var pitch_min_deg: float = -80.0
@export_range(-90.0, 90.0, 1.0, "Degrees") var pitch_max_deg: float = 80.0
@export var SpringArm: SpringArm3D
@export var MOUSE_SENSITIVITY = 0.003
@export var ENABLED := true
var mouse_delta = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta += event.relative

func rotate_mesh_towards_camera_xz(delta: float, mesh: Node3D, input_vector: Vector2, turn_speed: float = 16) -> void:
	if input_vector.length() == 0: return
	var input_angle = atan2(-input_vector.x, -input_vector.y)
	mesh.global_rotation.y = lerp_angle(mesh.global_rotation.y, SpringArm.global_rotation.y + input_angle, turn_speed * delta)
			
func _physics_process(delta: float) -> void:
	
	SpringArm.collision_mask = 0 if God.mode else 1
	
	if not ENABLED or Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		mouse_delta = Vector2.ZERO
		return
	
	var look_left_right = Input.get_axis("look_left", "look_right")
	var look_up_down = Input.get_axis("look_down", "look_up")
	mouse_delta.x += look_left_right * MOUSE_SENSITIVITY * 3000
	mouse_delta.y -= look_up_down * MOUSE_SENSITIVITY * 3000
	
	if mouse_delta.length() > 0:
		var new_x = SpringArm.global_rotation.x - mouse_delta.y * MOUSE_SENSITIVITY
		var new_y = SpringArm.global_rotation.y - mouse_delta.x * MOUSE_SENSITIVITY

		new_x = clamp(new_x, deg_to_rad(pitch_min_deg), deg_to_rad(pitch_max_deg)) #Constrain

		SpringArm.global_rotation.x = new_x
		SpringArm.global_rotation.y = new_y
		mouse_delta = Vector2.ZERO
