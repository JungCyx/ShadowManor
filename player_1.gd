extends CharacterBody3D

signal player_interact

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity := 1
var twist_input := 0
var pitch_input := 0
var in_air := false
var jumping := false

# === Hit tracking ===
var hit_count := 0
const MAX_HITS := 5
var is_dead := false

@onready var model = $Rogue
@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var camera = $TwistPivot/PitchPivot/Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		in_air = true
	else:
		in_air = false
	
	if Input.is_action_just_pressed("interact"):
		player_interact.emit()
	
	# Camera movement
	rotate_y(twist_input * delta)
	pitch_pivot.rotate_x(pitch_input * delta)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-50), deg_to_rad(40))
	twist_input = 0.0
	pitch_input = 0.0
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
	else:
		jumping = false

	# Sprint toggle
	SPEED = 8.0 if Input.is_action_pressed("sprint") else 5.0

	# Movement direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if input_dir.y > 0:
			SPEED = 5.0  # backward walking
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	model.play_animation(SPEED, input_dir, jumping, in_air)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity

# === Called by zombie.gd ===
func take_damage(amount: int) -> void:
	if is_dead:
		return

	hit_count += 1
	print("Player hit count:", hit_count)

	if hit_count >= MAX_HITS:
		die()

func die():
	is_dead = true
	set_physics_process(false)
	
	var label = get_node_or_null("/root/Node3D/DeathLabel/DLabel")
	if label:
		label.visible = true
		label.text = "You were caught!"

	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

# === Optional knockback ===
func hit(dir: Vector3) -> void:
	take_damage(1)
