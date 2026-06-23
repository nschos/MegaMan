extends Control

@onready var initial_button: Button = $Cutman_Button

func _ready() -> void:
	initial_button.grab_focus()

func _on_cutman_button_pressed() -> void:
	print("Botão pressionado!")
	get_tree().change_scene_to_file("res://main.tscn")
