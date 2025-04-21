extends CharacterBody3D

@onready var player = get_tree().get_root().find_node("player", true, false)

const SPEED := 4.0
const ATTACK_RANGE := 2.0
const VISION_RANGE := 10.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var state_machine = anim_tree.get("parameters/playback")


func _process(delta: float) -> void:
	if not player:
		return

	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)

	if distance_to_player <= VISION_RANGE:
		if distance_to_player <= ATTACK_RANGE:
			state_machine.travel("Attack")
		else:
			state_machine.travel("Run")
	else:
		state_machine.travel("GetUp")  

	match state_machine.get_current_node():
		"Run":
			follow_player(delta)
		"Attack":
			face_player()
		"GetUp":
			face_player()  

func follow_player(delta: float) -> void:
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()

	if next_nav_point != Vector3.ZERO:
		var direction = (next_nav_point - global_transform.origin).normalized()
		velocity = direction * SPEED
		move_and_slide()
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)

func face_player() -> void:
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	velocity = Vector3.ZERO
