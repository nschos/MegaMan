extends Area2D

var damage_amount
# Criamos a variável para que o Screw Driver possa modificá-la!
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Faz a bala andar na direção e velocidade que o Screw Driver mandou
	global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(2)

# Opcional: Se a bala sair da tela, destrua ela para não travar o jogo
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
