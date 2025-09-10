class_name StratagemLoader extends Control


var all_stratagems: Array


func _ready():
	all_stratagems = FileHelper.load_all_stratagems()
	load_on_top("res://Scenes/clock.tscn")


func load_on_top(scene_name):
	if get_child_count():
		get_child(0).queue_free()
	var scene = load(scene_name).instance()
	if scene is StratagemReceiver:
		scene.stratagems = all_stratagems.duplicate()
		scene.connect("load_scene", self, "_on_load_scene")
	add_child(scene)


func _on_load_scene(scene_name):
	load_on_top(scene_name)
