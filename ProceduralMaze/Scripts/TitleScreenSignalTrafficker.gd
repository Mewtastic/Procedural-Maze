extends Node

func _on_Start_button_up():
	get_tree().change_scene('res://Scenes/Demo.tscn')

func _on_Quit_button_up():
	get_tree().quit()

func _on_Button_button_up():
	get_tree().change_scene('res://Scenes/Tutorial.tscn')

func _on_Demo_button_up():
	get_tree().change_scene('res://Scenes/Main.tscn')
