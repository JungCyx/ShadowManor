extends CharacterBody3D

# === Configuration ===
const ACCELERATION = 10.0
const SPEED = 33.0
const ATTACK_RANGE = 1.0
const DETECTION_RANGE = 15.0
const GIVE_UP_RANGE = 1
const ATTACK_COOLDOWN = 1.0
const REPATH_DISTANCE = 1.0

@export var player_path: NodePath
@export var region: NavigationRegion3D

# === Nodes ===
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var ray_cast = $RayCast3D
# === State ===
var player = null
var zombie_state = ZombieStates.IDLE
var state_machine
var time_since_last_attack = 0.0
var wander_target = Vector3.ZERO
var time_since_last_wander = 0.0
var reached_wander_destination = false
var wandering = false

enum ZombieStates {
	IDLE,
	ATTACKING,
	WANDERING,
	RUNNING
}

# === Setup ===
func _ready():
	player = get_node(player_path)
	region = get_node("/root/Node3D/NavigationRegion3D")
	if (region == null):
		print("failed")

# === Main Loop ===
func _physics_process(delta):
	time_since_last_attack += delta
	time_since_last_wander += delta
	#print(time_since_last_wander)
	velocity = Vector3.ZERO

	var dist_to_player = global_position.distance_to(player.global_position)
	#print(dist_to_player)
	if dist_to_player <= DETECTION_RANGE and _player_is_visible():
		zombie_state = ZombieStates.RUNNING
		nav_agent.target_position = player.global_transform.origin
		#print("Running")
	elif dist_to_player <= ATTACK_RANGE and _player_is_visible():
		zombie_state = ZombieStates.ATTACKING
		nav_agent.target_position = player.global_transform.origin
		#print("Attacking")
	elif dist_to_player >= GIVE_UP_RANGE and time_since_last_wander >= 5 and not wandering:
		zombie_state = ZombieStates.WANDERING
		var wander_target = NavigationServer3D.region_get_random_point(region.get_rid(),1,false)
		nav_agent.target_position = wander_target
		reached_wander_destination = false
		print(nav_agent.target_position)
		wandering = true
		#print("Wandering")
	elif reached_wander_destination:
		zombie_state = ZombieStates.IDLE
	
	var next_nav_point = nav_agent.get_next_path_position()
	var direction = (next_nav_point - global_position).normalized()
	
	if zombie_state == ZombieStates.RUNNING or zombie_state == ZombieStates.WANDERING:
		velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 10.0)
	if zombie_state == ZombieStates.ATTACKING:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		velocity = Vector3.ZERO
	if zombie_state == ZombieStates.IDLE:
		velocity = Vector3.ZERO
	
	
	anim_tree.set("parameters/conditions/run", velocity > Vector3.ZERO)
	anim_tree.set("parameters/conitions/idle", velocity == Vector3.ZERO)
	move_and_slide()
	
# === State Transitions ===
#func _handle_state_transitions(dist_to_player):
	#if dist_to_player <= DETECTION_RANGE and _player_is_visible():
		#zombie_state = ZombieStates.RUNNING
		#nav_agent.target_position = player.global_transform.origin
		##print("Running")
	#elif dist_to_player <= ATTACK_RANGE and _player_is_visible():
		#zombie_state = ZombieStates.ATTACKING
		#nav_agent.target_position = player.global_transform.origin
		##print("Attacking")
	#elif dist_to_player >= GIVE_UP_RANGE and time_since_last_wander >= 5 and not reached_wander_destination:
		#zombie_state = ZombieStates.WANDERING
		#var wander_target = NavigationServer3D.region_get_random_point(region.get_rid(),1,false)
		#nav_agent.target_position = wander_target
		#print(nav_agent.target_position)
		##print("Wandering")
	#elif reached_wander_destination:
		#zombie_state = ZombieStates.IDLE
		#time_since_last_wander = 0
		#reached_wander_destination = false
		#print("Idle")
	#match state_machine.get_current_node():
		#"Wander":
			#if dist_to_player < DETECTION_RANGE:
				#state_machine.travel("Run")
#
		#"Run":
			#if dist_to_player > GIVE_UP_RANGE:
				#state_machine.travel("Wander")
				#if ready_to_target:
					#_set_new_wander_target()
					#ready_to_target = false
			#elif _can_attack(dist_to_player):
				#state_machine.travel("Attack")
#
		#"Attack":
			#if dist_to_player > ATTACK_RANGE:
				#state_machine.travel("Run")
			#elif dist_to_player > GIVE_UP_RANGE:
				#state_machine.travel("Wander")
				#if ready_to_target:
					#_set_new_wander_target()
					#ready_to_target = false
			#elif _can_attack(dist_to_player):
				#_perform_attack()
				#state_machine.travel("Run")

func _player_is_visible():
	ray_cast.target_position = ray_cast.to_local(player.global_position)
	if (ray_cast.get_collider() == player):
		return true
	else:
		return false

# === Movement ===
#func _process_movement(delta):
	#
	#if zombie_state == ZombieStates.RUNNING or zombie_state == ZombieStates.WANDERING:
		#velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
		#rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 10.0)
	#if zombie_state == ZombieStates.ATTACKING:
		#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		#velocity = Vector3.ZERO
	#if zombie_state == ZombieStates.IDLE:
		#velocity = Vector3.ZERO
	
	#match state_machine.get_current_node():
		#"Wander":
			#velocity = direction * SPEED * 0.5
			#rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 5.0)
#
		#"Run":
			#velocity = direction * SPEED
			#rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 10.0)
#
		#"Attack":
			#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			#velocity = Vector3.ZERO

# === Helpers ===
func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE - 0.1

func _can_attack(dist_to_player: float) -> bool:
	return dist_to_player < ATTACK_RANGE and time_since_last_attack >= ATTACK_COOLDOWN

func _perform_attack():
	if player and player.has_method("take_damage"):
		player.take_damage(34)
		time_since_last_attack = 0.0

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)


func _on_navigation_agent_3d_target_reached() -> void:
	print("I MADE IT!")
	reached_wander_destination = true
	wandering = false
	time_since_last_wander = 0 # Replace with function body.
