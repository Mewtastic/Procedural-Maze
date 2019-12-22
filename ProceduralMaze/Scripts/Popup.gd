extends CenterContainer

signal home()

var pause = false

func _process(delta):
	get_input()
	
func get_input():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		$Popup.show()

func _on_Resume_pressed():
	get_tree().paused = false
	$Popup.hide()
	pause = false

func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/3D title screen.tscn")
