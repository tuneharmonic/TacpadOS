class_name Lookup extends StratagemReceiver

onready var up_arrow: Texture = preload("res://Textures/Arrows/Up_Arrow.png")
onready var right_arrow: Texture = preload("res://Textures/Arrows/Right_Arrow.png")
onready var down_arrow: Texture = preload("res://Textures/Arrows/Down_Arrow.png")
onready var left_arrow: Texture = preload("res://Textures/Arrows/Left_Arrow.png")

onready var grid_container: GridContainer = $Panel/Control/VBoxContainer/ScrollContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
#	stratagems = FileHelper.load_all_stratagems()
	populate_grid()


func populate_grid():
	for stratagem in stratagems:
		create_row(stratagem)


func create_row(stratagem: Stratagem):
	var name_label = Label.new()
	name_label.text = stratagem.name
	name_label.size_flags_horizontal = 2 # Control.SizeFlags.SIZE_EXPAND
	grid_container.add_child(name_label)
	
	var icon = TextureRect.new()
	icon.texture = stratagem.icon
	icon.size_flags_horizontal = 2 # Control.SizeFlags.SIZE_EXPAND
	grid_container.add_child(icon)
	
	var code_container = HBoxContainer.new()
	code_container.size_flags_horizontal = 2 # Control.SizeFlags.SIZE_EXPAND
	for direction in stratagem.code:
		var direction_icon = TextureRect.new()
		direction_icon.texture = get_direction_icon(direction)
		code_container.add_child(direction_icon)
	grid_container.add_child(code_container)

func get_direction_icon(direction: int) -> Texture:
	var texture: Texture
	match direction:
		Stratagem.DIRECTION.UP:
			texture = up_arrow
		Stratagem.DIRECTION.RIGHT:
			texture = right_arrow
		Stratagem.DIRECTION.DOWN:
			texture = down_arrow
		Stratagem.DIRECTION.LEFT:
			texture = left_arrow
	return texture


func _on_back_button_pressed():
	emit_signal("load_scene", "res://Scenes/stratagem_input.tscn")


func _on_training_button_pressed():
	emit_signal("load_scene", "res://Scenes/stratagem_hero.tscn")
