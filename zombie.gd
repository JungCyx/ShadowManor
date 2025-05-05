extends CharacterBody3D

# === Configuration ===
const ACCELERATION = 10.0
const SPEED = 4.0
const ATTACK_RANGE = 2.0
const DETECTION_RANGE = 12.0
const GIVE_UP_RANGE = 18.0
const ATTACK_COOLDOWN = 2.0
const REPATH_DISTANCE = 1.0
const WANDER_RADIUS = 50.0

@export var player_path: NodePath

# === Nodes ===
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var ray_cast = $RayCast3D

# === State ===
var player = null
var time_since_last_attack = 0.0
var last_player_position = Vector3.ZERO
var wandering = false

enum ZombieState { IDLE, WANDERING, CHASING, ATTACKING }
var state = ZombieState.WANDERING

# === Setup ===
func _ready():
	player = get_node(player_path)
	_start_wandering()  

# === Main Loop ===
func _physics_process(delta):
	time_since_last_attack += delta

	var dist_to_player = global_position.distance_to(player.global_position)
	var player_visible = _player_is_visible()

	# === State Transitions ===
	match state:
		ZombieState.WANDERING:
			if dist_to_player < DETECTION_RANGE and player_visible:
				_start_chasing()
			elif nav_agent.is_navigation_finished():
				_start_wandering()

		ZombieState.CHASING:
			if dist_to_player > GIVE_UP_RANGE:
				_start_wandering()
			elif dist_to_player < ATTACK_RANGE and player_visible:
				_start_attacking()
			elif player.global_position.distance_to(last_player_position) > REPATH_DISTANCE:
				nav_agent.target_position = player.global_position
				last_player_position = player.global_position

		ZombieState.ATTACKING:
			if dist_to_player > ATTACK_RANGE:
				_start_chasing()
			elif dist_to_player > GIVE_UP_RANGE:
				_start_wandering()
			elif time_since_last_attack >= ATTACK_COOLDOWN:
				_perform_attack()

	# === Movement ===
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_transform.origin).normalized()

	if state in [ZombieState.WANDERING, ZombieState.CHASING]:
		velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 10.0)
	else:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		velocity = Vector3.ZERO

	move_and_slide()
	_update_animation()

# === WANDER ===
func _start_wandering():
	state = ZombieState.WANDERING
	wandering = true

	var random_offset = Vector3(
		randf_range(-WANDER_RADIUS, WANDER_RADIUS),
		0,
		randf_range(-WANDER_RADIUS, WANDER_RADIUS)
	)
	var wander_target = global_position + random_offset
	nav_agent.target_position = wander_target
	print(" Wandering to:", wander_target)

# === CHASE ===
func _start_chasing():
	state = ZombieState.CHASING
	wandering = false
	nav_agent.target_position = player.global_position
	last_player_position = player.global_position
	print(" Chasing player")

# === ATTACK ===
func _start_attacking():
	state = ZombieState.ATTACKING
	wandering = false
	velocity = Vector3.ZERO
	print(" Attacking player")

func _perform_attack():
	if player and player.has_method("take_damage"):
		player.take_damage(34)
		time_since_last_attack = 0.0
		print(" Attack hit!")

# === Raycast vision check
func _player_is_visible() -> bool:
	ray_cast.target_position = ray_cast.to_local(player.global_position)
	return ray_cast.get_collider() == player

# === Animation
func _update_animation():
	anim_tree.set("parameters/conditions/run", velocity.length() > 0.1)
	anim_tree.set("parameters/conditions/attack", state == ZombieState.ATTACKING and time_since_last_attack >= ATTACK_COOLDOWN)
