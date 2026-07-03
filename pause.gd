extends CanvasLayer

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
