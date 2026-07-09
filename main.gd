extends Node2D

var is_game_paused := false

@onready var megaman := $Megaman

@onready var megaman_HP := $CanvasLayer/Megaman_HP

const HP_format = "HP: %d"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SFXManager.play(SFXManager.GAME_START)
	megaman_HP.text = HP_format % megaman.HP
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("NES_SELECT"):
		for child in get_children():
			if is_game_paused:
				child.process_mode = Node.PROCESS_MODE_INHERIT
			else:
				child.process_mode = Node.PROCESS_MODE_DISABLED
				
				
		if is_game_paused:
			megaman.state_machine.state.finished.emit(MegaManState.TELEPORT)
				
		is_game_paused = not is_game_paused
		
	pass


func _on_megaman_megaman_hp_changed(HP: int) -> void:
	megaman_HP.text = HP_format % HP
	pass # Replace with function body.
