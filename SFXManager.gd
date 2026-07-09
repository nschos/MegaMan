extends CanvasLayer

const GAME_START : = "GAME_START"
const PAUSE_MENU : = "PAUSE_MENU"
const MENU_SELECT : = "MENU_SELECT"
const MEGAMAN_WARP : = "MEGAMAN_WARP"
const MEGA_BUSTER : = "MEGA_BUSTER"
const MEGAMAN_LAND : = "MEGAMAN_LAND"
const MEGAMAN_DAMAGE : = "MEGAMAN_DAMAGE"
const MEGAMAN_DEFEAT : = "MEGAMAN_DEFEAT"
const ENEMY_DAMAGE : = "ENEMY_DAMAGE"
const ENEMY_SHOOT : = "ENEMY_SHOOT"
const DINK : = "DINK"
const BIG_EYE : = "BIG_EYE"
const EXPLOSION : = "EXPLOSION"
const SUPER_ARM : = "SUPER_ARM"
const BEAM  = "BEAM"
const ROLLING_CUTTER : = "ROLLING_CUTTER"
const CUTMAN_SNIP : = "CUTMAN_SNIP"
const ENERGY_FILL : = "ENERGY_FILL"
const ONE_UP : = "ONE_UP"
const BONUS_BALL : = "BONUS_BALL"
const POINT_TALLY : = "POINT_TALLY"
const VANISHING_BLOCKS : = "VANISHING_BLOCKS"
const CONVEYOR_LIFT : = "CONVEYOR_LIFT"
const BOSS_GATE : = "BOSS_GATE"
const ERR : = "ERR"
const PI_PI_PI : = "PI_PI_PI"
const CUTMAN_MUSIC : = "CUTMAN_MUSIC"

const MUSIC_PATHS := {
	CUTMAN_MUSIC : "res://MUSIC/7 - Cut Man.mp3",
}

const SFX_PATHS := {
	GAME_START : "res://SFX/01 - GameStart.wav",
	PAUSE_MENU : "res://SFX/02 - PauseMenu.wav",
	MENU_SELECT : "res://SFX/03 - MenuSelect.wav",
	MEGAMAN_WARP : "res://SFX/04 - MegamanWarp.wav",
	MEGA_BUSTER : "res://SFX/05 - MegaBuster.wav",
	MEGAMAN_LAND : "res://SFX/06 - MegamanLand.wav",
	MEGAMAN_DAMAGE : "res://SFX/07 - MegamanDamage.wav",
	MEGAMAN_DEFEAT : "res://SFX/08 - MegamanDefeat.wav",
	ENEMY_DAMAGE : "res://SFX/09 - EnemyDamage.wav",
	ENEMY_SHOOT : "res://SFX/10 - EnemyShoot.wav",
	DINK : "res://SFX/11 - Dink.wav",
	BIG_EYE : "res://SFX/12 - BigEye.wav",
	EXPLOSION : "res://SFX/13 - Explosion.wav",
	SUPER_ARM : "res://SFX/14 - SuperArm.wav",
	BEAM : "res://SFX/17 - Beam.wav",
	ROLLING_CUTTER : "res://SFX/18 - RollingCutter.wav",
	CUTMAN_SNIP : "res://SFX/19 - CutmanSnip.wav",
	ENERGY_FILL : "res://SFX/24 - EnergyFill.wav",
	ONE_UP : "res://SFX/25 - 1up.wav",
	BONUS_BALL : "res://SFX/26 - BonusBall.wav",
	POINT_TALLY : "res://SFX/27 - PointTally.wav",
	VANISHING_BLOCKS : "res://SFX/28 - VanishingBlocks.wav",
	CONVEYOR_LIFT : "res://SFX/29 - ConveyorLift.wav",
	BOSS_GATE : "res://SFX/30 - BossGate.wav",
	ERR : "res://SFX/33 - Err.wav",
	PI_PI_PI : "res://SFX/34 - PiPiPi.wav",
}


const POOL_SIZE := 8

var _players: Array[AudioStreamPlayer] = []
var _next_player_index := 0
var _stream_cache: Dictionary = {}
var _music_player: AudioStreamPlayer
var _current_music: String = ""

func _ready() -> void:
	layer = 1

	process_mode = Node.PROCESS_MODE_ALWAYS

	var bus_name := "SFX" if AudioServer.get_bus_index("SFX") != -1 else "Master"

	for i in POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.name = "SFXPlayer%d" % i
		player.bus = bus_name
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(player)
		_players.append(player)

	for sfx_name in SFX_PATHS.keys():
		_load_stream(sfx_name)
		
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.bus = "Music" if AudioServer.get_bus_index("Music") != -1 else "Master"
	_music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_music_player)
	_music_player.finished.connect(_on_music_finished)

	play_music(CUTMAN_MUSIC)

func play(sfx_name: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if not SFX_PATHS.has(sfx_name):
		push_warning("SFXManager: efeito sonoro '%s' não existe." % sfx_name)
		return

	var stream := _load_stream(sfx_name)
	if stream == null:
		return

	var player := _players[_next_player_index]
	_next_player_index = (_next_player_index + 1) % _players.size()

	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()

func _load_stream(sfx_name: String) -> AudioStream:
	if _stream_cache.has(sfx_name):
		return _stream_cache[sfx_name]

	var path: String = SFX_PATHS[sfx_name]
	var stream := load(path) as AudioStream
	if stream == null:
		push_error("SFXManager: falha ao carregar '%s'." % path)
		return null

	_stream_cache[sfx_name] = stream
	return stream

func play_music(music_name: String, volume_db: float = 0.0) -> void:
	if not MUSIC_PATHS.has(music_name):
		push_warning("SFXManager: música '%s' não existe." % music_name)
		return

	if _current_music == music_name and _music_player.playing:
		return

	var path: String = MUSIC_PATHS[music_name]
	var stream := load(path) as AudioStream
	if stream == null:
		push_error("SFXManager: falha ao carregar música '%s'." % path)
		return

	if stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamOggVorbis:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD

	_current_music = music_name
	_music_player.stream = stream
	_music_player.volume_db = volume_db
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()
	_current_music = ""

func _on_music_finished() -> void:
	if _current_music != "" and MUSIC_PATHS.has(_current_music):
		_music_player.play()
