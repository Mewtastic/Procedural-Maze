extends Camera

func _on_RequestHandler_switch_cam():
	if current:
		current = false
	else:
		current = true