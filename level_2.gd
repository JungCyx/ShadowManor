extends Node3D

# UI references
@onready var death_label = $DeathLabel/DLabel  # Label inside the CanvasLayer
@onready var vbox_container = $VBoxContainer   # Settings menu container
@onready var resume_button = $VBoxContainer/Resume
@onready var exit_button = $VBoxContainer/ExitGame
@onready var health_bar = $Health/Healthbar       # Health bar under CanvasLayer

# Player reference
@onready var player = get_node("/root/Node3D/StaticBody3D")
@onready var nav_region = get_node("NavigationRegion3D")

# Health variables
var max_health = 100
var current_health = 100

func _ready() -> void:
	death_label.visible = false
	vbox_container.visible = false
	update_health_bar()

	# Connect buttons
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _process(delta: float) -> void:
	# Toggle settings menu
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_settings_menu()

	# Test keys: Damage/heal
	if Input.is_action_just_pressed("ui_accept"):  # Enter key
		take_damage(10)
	if Input.is_action_just_pressed("ui_select"):  # Shift key
		heal(5)


func show_death_label():
	death_label.text = "You Died"
	death_label.visible = true

func reset_player_position():
	player.global_transform.origin = Vector3(0, 1, 0)
	player.linear_velocity = Vector3.ZERO

func toggle_settings_menu():
	vbox_container.visible = not vbox_container.visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if vbox_container.visible else Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	vbox_container.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_exit_pressed():
	get_tree().quit()

# ----- Health system -----
func update_health_bar():
	health_bar.value = current_health

func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	update_health_bar()

func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	update_health_bar()
