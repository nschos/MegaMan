class_name SuperCutterEnemy extends Enemy

# Variáveis para criar o arco de voo
@export var jump_force: float = -400.0  # Impulso para cima (negativo no Godot)
@export var fall_gravity: float = 900.0 # NOME ALTERADO AQUI
@export var horizontal_speed: float = 150.0
@export var direction: float = -1.0     # -1 voa para a esquerda, 1 para a direita

# Vetor para acumular a velocidade simulada
var velocity: Vector2 = Vector2.ZERO

# NOME DO NÓ AJUSTADO PARA O SEU PROJETO
@onready var sprite: AnimatedSprite2D = $inimigo3 

func _ready() -> void:
	# ATENÇÃO: super() é obrigatório aqui para rodar o _ready do pai (Enemy)
	# e não quebrar o seu sistema de VisibleOnScreenNotifier2D!
	super() 
	
	# O Super Cutter geralmente morre com 1 tiro do Mega Buster
	initial_HP = 5 
	
	# Inicia o movimento
	_reset()

# Sobrescrevemos o _reset do pai para aplicar a física inicial
func _reset() -> void:
	velocity.y = jump_force
	velocity.x = horizontal_speed * direction
	

func _physics_process(delta: float) -> void:
	# 1. Aplica a gravidade nova para puxar a tesoura para baixo gradualmente
	velocity.y += fall_gravity * delta
	
	# 2. Move a Area2D somando a velocidade à posição atual
	position += velocity * delta

# Sinal conectado a partir do nó Area2D para causar dano ao Mega Man
func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(4)
