class_name RollingCutter extends Area2D

var target: Vector2
var direction: Vector2

@export var cutman: CutMan
@export var rolling_cutter_speed := 300

enum RollingCutterState { ATTACK, RETURN, WAIT }

var current_state := RollingCutterState.WAIT

func _ready() -> void:
	assert(cutman, "Rolling cutter missing cutman!")
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == RollingCutterState.ATTACK:
		global_position -= direction * delta * rolling_cutter_speed
	elif current_state == RollingCutterState.RETURN:
		self.target = cutman.global_position
		direction = (self.global_position - target).normalized()
		global_position -= direction * delta * rolling_cutter_speed

	pass

func attack(_target: Vector2):
	current_state = RollingCutterState.ATTACK
	self.process_mode = Node.PROCESS_MODE_INHERIT
	self.global_position = cutman.global_position
	self.visible = true
	self.target = _target
	direction = (self.global_position - _target).normalized()
	pass


func _on_area_exited(area: Area2D) -> void:
	if area is RollingCutterArena:
		#print("saiu da arena!")
		current_state = RollingCutterState.RETURN
		self.target = cutman.global_position
		direction = (self.global_position - target).normalized()
		pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if current_state == RollingCutterState.RETURN:
		if body is CutMan:
			current_state = RollingCutterState.WAIT
			self.visible = false
			set_deferred("self.process_mode", Node.PROCESS_MODE_DISABLED)
			cutman.take_rolling_cutter()
	if body is MegaMan:
		body.take_damage(3)
	pass # Replace with function body.
