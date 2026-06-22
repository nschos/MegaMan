extends Control

@onready var initial_button: Button = $Cutman_Button

func _ready() -> void:
	# Força o jogo a começar com este botão selecionado
	initial_button.grab_focus()

func _on_cutman_button_pressed() -> void:
	print("Botão pressionado!")
	get_tree().change_scene_to_file("res://main.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("pressed") # Aciona o código do botão
