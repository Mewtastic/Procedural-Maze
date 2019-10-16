extends Node

signal maze_complete()
signal switch_cam()

const WIN_CONDITION = 3

var collected = 0
var confirm = true

func _process(delta):
	get_input()
	if confirm and collected >= WIN_CONDITION:
		confirm = false
		$Timer.start()

func _on_Collect_body_entered(body):
	collected += 1

func _on_Collect2_body_entered(body):
	collected += 1

func _on_Collect3_body_entered(body):
	collected += 1

func _on_Timer_timeout():
	emit_signal("maze_complete")

func _on_GameFin_retry():
	get_tree().reload_current_scene()

func _on_GameFin_home():
	get_tree().change_scene("res://Scenes/3D title screen.tscn")

func get_input():
	if Input.is_action_just_pressed("switchcam"):
		emit_signal("switch_cam")
