extends RigidBody3D  # Player's physics behavior

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var speed = 0.0

@onready var model = $Rogue
@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var camera = $TwistPivot/PitchPivot/Camera3D
@onready var crosshair = $TwistPivot/PitchPivot/Camera3D/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	var jump := Vector3.ZERO
	
	if Input.is_action_pressed("sprint"):
		speed = 1300.0
	else:
		speed = 800.0
	
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	jump.y = Input.get_action_raw_strength("jump")
	
	if linear_velocity.y <= 0.0000014:
		apply_central_force(jump * 10000.0 * delta)
		
	apply_central_force(twist_pivot.basis * input * speed * delta)

	# Handling mouse and camera movement
	var direction_input = twist_pivot.basis.z
	var look_direction = Vector2(direction_input.z, direction_input.x)
	model.rotation.y = look_direction.angle() - deg_to_rad(180)
	
	if input.length() <= 0:
		speed = 0
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-50), deg_to_rad(40))

	twist_input = 0.0
	pitch_input = 0.0
	
	var crosshair_placement = get_viewport().size
	crosshair.size.x = crosshair_placement.x / crosshair.scale.x
	crosshair.size.y = crosshair_placement.y / crosshair.scale.y
	
	model.play_animation(speed, input)

# Handle input for mouse movement
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
