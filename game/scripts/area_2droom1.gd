extends Area2D

var entered: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":  
		entered = true
		print("Player entered area")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":  
		entered = false
		print("Player exited area")

func _process(delta: float) -> void:
	if entered:
		print("In area. Waiting for button press")
		if Input.is_action_just_pressed("ui_accept"):
			print("Key pressed")
			get_tree().change_scene_to_file("res://game/scenes/room2.tscn")
