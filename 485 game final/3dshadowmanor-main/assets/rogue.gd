extends Node3D

@onready var animPlayer = $AnimationPlayer/AnimationTree
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_animation(speed, vector, jumping, falling):
	animPlayer.set("parameters/conditions/Idle", vector.y == 0 and vector.x == 0 and not jumping and not falling)
	animPlayer.set("parameters/conditions/Walking", speed == 5.0 and vector.y < 0 and not jumping and not falling)
	animPlayer.set("parameters/conditions/Running", speed == 8.0 and vector.y < 0 and vector.x == 0 and not jumping and not falling)
	animPlayer.set("parameters/conditions/Running_Left", speed == 8.0 and vector.x < 0 and not jumping and not falling)
	animPlayer.set("parameters/conditions/Running_Right", speed == 8.0 and vector.x > 0 and not jumping and not falling)
	animPlayer.set("parameters/conditions/Walking_Back", speed == 5.0 and vector.y > 0 and not jumping and not falling)
	animPlayer.set("parameters/conditions/Jumping", falling)
	animPlayer.set("parameters/conditions/Landed", not falling)
