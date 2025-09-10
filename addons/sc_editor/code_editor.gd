# code_editor.gd
extends EditorProperty

var property_control = preload("res://addons/sc_editor/direction_inputs.tscn").instance()
var current_value = []
var updating = false

func _init():
	add_child(property_control)
	add_focusable(property_control)
	refresh_text()
	property_control.get_node("Control/Up").connect("pressed", self, "_on_up_pressed")
	property_control.get_node("Control/Right").connect("pressed", self, "_on_right_pressed")
	property_control.get_node("Control/Down").connect("pressed", self, "_on_down_pressed")
	property_control.get_node("Control/Left").connect("pressed", self, "_on_left_pressed")
	property_control.get_node("Control/UndoButton").connect("pressed", self, "_on_undo_pressed")
	property_control.get_node("Control/ClearButton").connect("pressed", self, "_on_clear_pressed")


func _on_up_pressed():
	if updating:
		return
	
	if current_value == null:
		current_value = []
	
	current_value.append(1)
	refresh_text()
	emit_changed(get_edited_property(), current_value)

func _on_right_pressed():
	if updating:
		return
	
	if current_value == null:
		current_value = []
	
	current_value.append(2)
	refresh_text()
	emit_changed(get_edited_property(), current_value)

func _on_down_pressed():
	if updating:
		return
	
	if current_value == null:
		current_value = []
	
	current_value.append(3)
	refresh_text()
	emit_changed(get_edited_property(), current_value)

func _on_left_pressed():
	if updating:
		return
	
	if current_value == null:
		current_value = []
	
	current_value.append(4)
	refresh_text()
	emit_changed(get_edited_property(), current_value)

func _on_undo_pressed():
	if updating:
		return
	
	if current_value == null:
		current_value = []
	
	current_value.pop_back()
	refresh_text()
	emit_changed(get_edited_property(), current_value)

func _on_clear_pressed():
	if updating:
		return
	
	if current_value == null:
		current_value = []
	
	current_value.clear()
	refresh_text()
	emit_changed(get_edited_property(), current_value)

func update_property():
	var new_value = get_edited_object()[get_edited_property()]
	if new_value == current_value:
		return
	
	updating = true
	current_value = new_value
	refresh_text()
	print(current_value)
	updating = false

func stringify_code(code: Array) -> String:
	var string_code = ""
	
	for direction in code:
		match direction:
			Stratagem.DIRECTION.UP:
				string_code = string_code + "^ "
			Stratagem.DIRECTION.RIGHT:
				string_code = string_code + "> "
			Stratagem.DIRECTION.DOWN:
				string_code = string_code + "v "
			Stratagem.DIRECTION.LEFT:
				string_code = string_code + "< "
	
	return string_code.strip_edges()

func refresh_text():
	var label = property_control.get_node("Label")
	label.text = stringify_code(current_value)
