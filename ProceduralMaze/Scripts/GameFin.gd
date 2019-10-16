extends Control

onready var time = $CenterContainer/Column/Time

signal retry()
signal home()

var check = true

func initialize(total_play_time : float) -> void:
	var minutes : String = str(int(total_play_time / 60))
	var seconds : String = str(int(fmod(total_play_time, 60)))
	var time_text = "Total Time: %s m  %s s" % [minutes, seconds]
	if check:
		time.text = time_text
		check = false

func _on_RequestHandler_maze_complete():
	show()
	$CenterContainer/Column/HBoxContainer/TryAgain.grab_focus()

func _on_TryAgain_button_up():
	emit_signal("retry")

func _on_Main_Menu_button_up():
	emit_signal("home")

func _on_Tutorial_maze_complete():
	show()
	$CenterContainer/Column/HBoxContainer/TryAgain.grab_focus()
