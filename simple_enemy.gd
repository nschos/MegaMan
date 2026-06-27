extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	print("sub class ready!")
	pass # Replace with function body.



func _on_timer_timeout() -> void:
	$Sprite2D.flip_h = !$Sprite2D.flip_h
	pass # Replace with function body.
