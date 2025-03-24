extends Node2D
@onready var start_button = $MainMenuUi/StartButton  # Reference to the Start Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_button = $MainMenuUi/StartButton
	if start_button:
		start_button.pressed.connect(_on_button_button_down)
	else:
		print("Error: StartButton not found!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




	

func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://game/scenes/ShadowManorGame.tscn")
