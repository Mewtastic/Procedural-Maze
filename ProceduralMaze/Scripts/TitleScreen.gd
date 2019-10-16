extends Control

func _on_3D_title_screen_gendone():
	show()
	$CenterContainer/VBoxContainer/buttons/Start.grab_focus()
