extends Control

@onready var initial_button: Button = $Cutman_Button

func _ready() -> void:
	# Força o jogo a começar com este botão selecionado
	initial_button.grab_focus()
