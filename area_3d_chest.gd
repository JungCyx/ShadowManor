extends Area3D




var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func interact(player: CharacterBody3D) -> void:
	if is_open:
		return
	
	is_open = true
	print("chest opened")
	
	if player.has_method("add_key"):
		player.add_key()


func _on_body_entered(body: Node3D) -> void:
	pass
		
		
func _on_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
