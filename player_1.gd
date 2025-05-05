extends CharacterBody3D

signal player_interact

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity := 1
var twist_input := 0
var pitch_input := 0
var in_air := false
var jumping := false
var key_count = 0
var time_since_last_stamina_action = 0
# === Hit tracking ===
var hit_count := 0
const MAX_HITS := 5
var is_dead := false

@onready var model = $Rogue
@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var camera = $TwistPivot/PitchPivot/Camera3D
@onready var stamina_bar = $CanvasLayer/StaminaBar
@onready var health_bar = $CanvasLayer/HealthBar
@onready var key_label = $CanvasLayer/KeyLabel


#key stuff
func add_key():
	key_count += 1
	print("keys: ", key_count)
	key_label.text = "Keys: %d" % key_count


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$CanvasLayer/BloodSplatter.visible = false

func _physics_process(delta: float) -> void:
	
	time_since_last_stamina_action += delta
	
	$CanvasLayer/BoxContainer/Label.hide()
	if %seeCast.is_colliding():
		var target = %seeCast.get_collider()
		if target.has_method("interact"):
			$CanvasLayer/BoxContainer/Label.show()
			if Input.is_action_just_pressed("interact"):
				target.interact(self)
		
		
		
	if is_dead:
		return
	
	if time_since_last_stamina_action >= 5:
		stamina_bar.value += 0.5
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
	if Input.is_action_just_pressed("jump") and is_on_floor() and stamina_bar.value >= 10:
		velocity.y = JUMP_VELOCITY
		jumping = true
		time_since_last_stamina_action = 0
		stamina_bar.value -= 10
	else:
		jumping = false

	# Sprint toggle
	if Input.is_action_pressed("sprint") and stamina_bar.value > 0.05:
		SPEED = 8.0
		stamina_bar.value -= 0.05
		time_since_last_stamina_action = 0
	else:
		SPEED = 5.0

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
# === Called by zombie.gd ===
func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	health_bar.value -= amount
	# Show blood splatter when health is below a certain threshold (e.g., 10%)
	if health_bar.value <= health_bar.max_value * 0.1:
		$CanvasLayer/BloodSplatter.visible = true 
		$CanvasLayer/BloodSplatter.texture = preload("res://bloodpic.png")  
	if health_bar.value == 0:
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
