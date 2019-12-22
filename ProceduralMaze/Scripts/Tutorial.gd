extends Spatial

onready var player = $Player
onready var mark = $EnergyMarker
onready var finMenu = $GameFin

var collected = 0
var play_time = 0

signal maze_complete()

func _ready():
	$world.environment.fog_enabled = true

func _process(delta):
	play_time += delta

func _on_Collect_body_entered(body):
	collected += 1
	if collected > 2:
		$Timer.start()

func _on_Timer_timeout():
	var total_play_time = play_time
	$world.environment.fog_enabled = false
	emit_signal("maze_complete")
	$Camera/SpotLight.visible = true
	finMenu.initialize(total_play_time)

func _on_GameFin_retry():
	get_tree().reload_current_scene()

func _on_GameFin_home():
	get_tree().change_scene("res://Scenes/3D title screen.tscn")

func _on_Collect2_body_entered(body):
	collected += 1
	if collected > 2:
		$Timer.start()

func _on_Player_green():
	mark.translation = player.translation
	mark.rotation_degrees = player.rotation_degrees
	mark.visible = true

func _on_Player_home():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/3D title screen.tscn")
