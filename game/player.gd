extends CharacterBody2D


const SPEED = 150.0
var playerDirection = "N"
var playerState = "IDLE"
	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	
func get_input():
	#check for key input and apply direction
	velocity = Vector2.ZERO
	if Input.is_key_label_pressed(KEY_D):
		velocity.x += 1
		playerDirection = "E"
	if Input.is_key_label_pressed(KEY_A):
		velocity.x -= 1
		playerDirection = "W"
	if Input.is_key_label_pressed(KEY_W):
		velocity.y -= 1
		playerDirection = "N"
	if Input.is_key_label_pressed(KEY_S):
		velocity.y += 1
		playerDirection = "S"
		
	if velocity != Vector2.ZERO:
		playerState="MOVING"
		if velocity.x > 0 and velocity.y > 0:
			playerDirection = "SE"
		if velocity.x < 0 and velocity.y > 0:
			playerDirection = "SW"
		if velocity.x > 0 and velocity.y < 0:
			playerDirection = "NE"
		if velocity.x < 0 and velocity.y < 0:
			playerDirection = "NW"
	else: 
		playerState = "IDLE"
	start_animation(playerDirection, playerState)
	velocity = velocity.normalized() * SPEED

func start_animation(direction, state):
	if state == "IDLE":
		if direction == "E":
			$CollisionShape2D/playerSprite.animation = "IdleRight"
		if direction == "W":
			$CollisionShape2D/playerSprite.animation = "IdleLeft"
		if direction == "N":
			$CollisionShape2D/playerSprite.animation = "IdleBack"
		if direction == "S":
			$CollisionShape2D/playerSprite.animation = "IdleFront"
		if direction == "NE":
			$CollisionShape2D/playerSprite.animation = "IdleRightBack"
		if direction == "NW":
			$CollisionShape2D/playerSprite.animation = "IdleLeftBack"
		if direction == "SE":
			$CollisionShape2D/playerSprite.animation = "IdleRightFront"
		if direction == "SW":
			$CollisionShape2D/playerSprite.animation = "IdleLeftFront"
	else:
		if direction == "E":
			$CollisionShape2D/playerSprite.animation = "RunRight"
		if direction == "W":
			$CollisionShape2D/playerSprite.animation = "RunLeft"
		if direction == "N":
			$CollisionShape2D/playerSprite.animation = "RunUp"
		if direction == "S":
			$CollisionShape2D/playerSprite.animation = "RunDown"
		if direction == "NE":
			$CollisionShape2D/playerSprite.animation = "RunRightUp"
		if direction == "NW":
			$CollisionShape2D/playerSprite.animation = "RunLeftUp"
		if direction == "SE":
			$CollisionShape2D/playerSprite.animation = "RunRightDown"
		if direction == "SW":
			$CollisionShape2D/playerSprite.animation = "RunLeftDown"
	if !$CollisionShape2D/playerSprite.is_playing():
		$CollisionShape2D/playerSprite.play()
