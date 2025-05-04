extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var exit_button =$VBoxContainer/ExitButton
@onready var music = $AudioStreamPlayer
@onready var sfx = $AudioStreamPlayer2

func _ready():
	music.play()
	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	start_button.mouse_entered.connect(_on_hover)
	exit_button.mouse_entered.connect(_on_hover)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Level.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_hover():
	sfx.play()
