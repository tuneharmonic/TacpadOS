extends EditorInspectorPlugin

var code_editor = preload("res://addons/sc_editor/code_editor.gd")

func can_handle(object):
	return object is Stratagem

func parse_property(object, type, path, hint, hint_text, usage):
	if path == "code":
		add_property_editor(path, code_editor.new())
		return true
	else:
		return false
