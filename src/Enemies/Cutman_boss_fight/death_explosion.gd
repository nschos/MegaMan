extends Node2D

const explosion_sprite_scene := preload("res://src/Enemies/Cutman_boss_fight/explosion_animated_sprite.tscn")

class SpriteMovement:
	var speed: float
	var direction: Vector2
	var node: Node2D
	
var arr: Array[SpriteMovement] = []

const speed_1 := 30.0
const speed_2 := 60.0

const directions_1 := [0, 90, 180, 270]
const directions_2 := [0, 45, 90, 135, 180, 225, 270, 315]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# inner explosions
	for i in range(4):
		var explosion = explosion_sprite_scene.instantiate()
		var sprite = SpriteMovement.new()
		sprite.speed = speed_1
		sprite.direction = Vector2.from_angle(deg_to_rad(directions_1[i]))
		sprite.node = explosion
		arr.append(sprite)
		add_child(explosion)
	# outer explosions
	for i in range(8):
		var explosion = explosion_sprite_scene.instantiate()
		var sprite = SpriteMovement.new()
		sprite.speed = speed_2
		sprite.direction = Vector2.from_angle(deg_to_rad(directions_2[i]))
		sprite.node = explosion
		arr.append(sprite)
		add_child(explosion)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var arr_size = arr.size()
	for i in arr_size:
		var sprite = arr[i]
		var node = sprite.node
		if node == null:
			continue
		node.position += delta * sprite.speed * sprite.direction
	pass
