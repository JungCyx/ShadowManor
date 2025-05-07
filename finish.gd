extends Area3D

@export var game_end_label: Label  # Reference to the GameEnd label

var detection_enabled = false

func _ready() -> void:
	if game_end_label:
		game_end_label.visible = false

	# Enable detection after 0.5 seconds
	await get_tree().create_timer(0.5).timeout
	detection_enabled = true

func _on_body_entered(body: Node3D) -> void:
	if detection_enabled and body.name == "Player":
		print("Game ended")
		
		var label = get_node_or_null("/root/Node3D/CanvasLayer/GameEnd")
		if label:
			label.text = "You Escape the ShadowManor!"
			label.visible = true
		else:
			print("GameEnd label not found!")
