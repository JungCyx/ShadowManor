extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play_animation(movement_type):
	$AnimationPlayer.play(movement_type)
