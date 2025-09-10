class_name ClockControl extends StratagemReceiver

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		emit_signal("load_scene", "res://Scenes/stratagem_input.tscn")
