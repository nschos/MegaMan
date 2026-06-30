extends Enemy

var frame_counter := 0

const closed_window    := 120
const open_1_window    := closed_window + 7
const open_2_window    := open_1_window + 7
const open_3_window    := open_2_window + 50
const shoot_1          := open_3_window
const closing_1_window := open_3_window + 7
const closing_2_window := closing_1_window + 7

@onready var animated_sprites = $beak_sprites

#enum Sprite { CLOSED, OPEN_1, OPEN_2, OPEN_3 }
#
#var current_sprite: Sprite = Sprite.CLOSED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	if frame_counter <= closed_window:
		#current_sprite = Sprite.CLOSED
		animated_sprites.play("close")
	elif frame_counter <= open_1_window:
		#current_sprite = Sprite.OPEN_1
		animated_sprites.play("open_1")
	elif frame_counter <= open_2_window:
		#current_sprite = Sprite.OPEN_2
		animated_sprites.play("open_2")
	elif frame_counter <= open_3_window:
		#current_sprite = Sprite.OPEN_3
		animated_sprites.play("open_3")
		if frame_counter == shoot_1:
			shoot($Bullet1)
	elif frame_counter <= closing_1_window:
		#current_sprite = Sprite.OPEN_3
		animated_sprites.play("open_2")
	elif frame_counter <= closing_2_window:
		#current_sprite = Sprite.OPEN_3
		animated_sprites.play("open_1")
	else:
		frame_counter = 0
	
	
	
	frame_counter += 1
	
	pass
	
func shoot(bullet: Area2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(bullet, "position", self.position + Vector2(-500, 0), 1)
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		#print("megaman direct impact!")
		body.take_damage(1)
	pass # Replace with function body.
