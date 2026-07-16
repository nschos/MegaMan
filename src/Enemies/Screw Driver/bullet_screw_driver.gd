extends Area2D

var damage_amount
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(2)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
