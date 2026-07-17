extends AnimatedSprite2D


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()
	pass # Replace with function body.
