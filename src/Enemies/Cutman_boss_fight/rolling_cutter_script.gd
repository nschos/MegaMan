class_name RollingCutter extends Enemy


var target: Vector2
var direction: Vector2

@export var cutman: CutMan

@export var rolling_cutter_speed := 300

var isAttacking := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isAttacking and direction:
		global_position -= direction * delta * rolling_cutter_speed
		
		if return_to_cutman:
			if self.global_position.distance_to(cutman.global_position) < 8:
				isAttacking = false
				self.visible = false
				cutman.assembled = true
		pass
	pass

func attack(_target: Vector2):
	self.global_position = cutman.global_position
	self.visible = true
	return_to_cutman = false
	isAttacking = true
	self.target = _target
	direction = (self.global_position - _target).normalized()
	pass

var return_to_cutman := false

func _on_area_2d_area_exited(area: Area2D) -> void:
	print("saiu da area!")
	direction = (self.global_position - cutman.global_position).normalized()
	return_to_cutman = true
	pass # Replace with function body.
