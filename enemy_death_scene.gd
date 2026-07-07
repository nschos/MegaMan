extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("explosion!!")
	self.play("explosion")
	await self.animation_finished
	self.queue_free()
	pass # Replace with function body.
