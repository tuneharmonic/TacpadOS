class_name ClockControl extends StratagemReceiver

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		emit_signal("load_scene", "res://Scenes/stratagem_input.tscn")
