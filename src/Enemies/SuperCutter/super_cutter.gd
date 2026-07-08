class_name SuperCutter extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

const bullet_scene := preload("res://src/Enemies/SuperCutter/SuperCutterBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#sprite.visible = false
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var megaman: MegaMan = null

@onready var timer := $Timer

func _on_body_entered(body: Node2D) -> void:
	print("teste")
	if body is MegaMan:
		megaman = body
		print("megaman!!")
		timer.start()
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	if megaman is MegaMan:
		megaman = null
		#timer.stop()
	pass # Replace with function body.

func attack_megaman() -> void:
	if megaman:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		var tween = get_tree().create_tween()
		tween.tween_method(
			func(tween_value: float):
				attack_path(tween_value, bullet, megaman.global_position), 
			0.0, 
			1.0, 
			1.0
		)
		#tween.tween_property(sprite, "position.x", megaman.global_position.x, 1.0)
		#tween.tween_property(sprite, "position", megaman.global_position, 1.0)		
	pass
	
func attack_path(delta: float, bullet: Node2D, final_position: Vector2) -> void:
	
	pass

func _on_timer_timeout() -> void:
	if megaman == null:
		timer.stop()
	else:
		#print("attack!")
		attack_megaman()
		
	pass # Replace with function body.
