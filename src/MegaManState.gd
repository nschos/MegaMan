class_name MegaManState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"

var megaman: MegaMan

func _ready() -> void:
	await owner.ready
	megaman = owner as MegaMan
	assert(megaman != null, "The MegaManState state type must be used only in the player scene. It needs the owner to be a Player node.")
