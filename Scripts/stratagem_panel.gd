class_name StratagemPanel extends Panel


const MAX_INPUTS = 10

onready var stratagem_icon: TextureRect = $StratagemIcon
onready var stratagem_label: Label = $StratagemLabel
onready var stratagem_readout: HBoxContainer = $StratagemReadout
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

onready var stratagem_arrow = preload("res://Scenes/stratagem_arrow.tscn")
onready var up_arrow_texture: Texture = preload("res://Textures/Arrows/Up_Arrow.png")
onready var right_arrow_texture: Texture = preload("res://Textures/Arrows/Right_Arrow.png")
onready var down_arrow_texture: Texture = preload("res://Textures/Arrows/Down_Arrow.png")
onready var left_arrow_texture: Texture = preload("res://Textures/Arrows/Left_Arrow.png")

onready var key1_sound: AudioStreamMP3 = preload("res://Sounds/key1.mp3")
onready var key2_sound: AudioStreamMP3 = preload("res://Sounds/key2.mp3")
onready var key3_sound: AudioStreamMP3 = preload("res://Sounds/key3.mp3")
onready var final_key_sound: AudioStreamMP3 = preload("res://Sounds/finalkey.mp3")
var normal_keys: Array

var stratagems: Array
var input_buffer: Array

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	clear_stratagem()
	stratagems = FileHelper.load_all_stratagems()
	normal_keys = [ key1_sound, key2_sound, key3_sound ]


func add_to_input_buffer(direction: int):
	if input_buffer.size() < MAX_INPUTS:
		input_buffer.append(direction)
		add_arrow_to_readout(direction)
	else:
		input_buffer[input_buffer.size() - 1] = direction
		change_last_readout_arrow(direction)
	check_matching_stratagem()


func check_matching_stratagem():
	var matching = false
	for stratagem in stratagems:
		if stratagem.code.hash() == input_buffer.hash():
			matching = true
			display_stratagem(stratagem)
			play_final_key_sound()
	if not matching:
		clear_stratagem_icon()
		clear_stratagem_label()
		play_random_normal_key_sound()

func play_random_normal_key_sound():
	var random_key_sound = normal_keys.pick_random()
	audio_stream_player.stream = random_key_sound
	audio_stream_player.play()

func play_final_key_sound():
	audio_stream_player.stream = final_key_sound
	audio_stream_player.play()

# UI functions
func clear_stratagem():
	clear_stratagem_icon()
	clear_stratagem_label()
	clear_stratagem_readout()


func clear_stratagem_icon():
	stratagem_icon.texture = null


func clear_stratagem_label():
	stratagem_label.text = ""


func clear_stratagem_readout():
	for child in stratagem_readout.get_children():
		child.queue_free()


func display_stratagem(stratagem: Stratagem):
	stratagem_icon.texture = stratagem.icon
	stratagem_label.text = stratagem.name


func add_arrow_to_readout(direction: int):
	var arrow = stratagem_arrow.instance()
	match direction:
		Stratagem.DIRECTION.UP:
			arrow.texture = up_arrow_texture
		Stratagem.DIRECTION.RIGHT:
			arrow.texture = right_arrow_texture
		Stratagem.DIRECTION.DOWN:
			arrow.texture = down_arrow_texture
		Stratagem.DIRECTION.LEFT:
			arrow.texture = left_arrow_texture
	stratagem_readout.add_child(arrow)


func change_last_readout_arrow(direction: int):
	var arrow = stratagem_readout.get_child(stratagem_readout.get_child_count() - 1)
	match direction:
		Stratagem.DIRECTION.UP:
			arrow.texture = up_arrow_texture
		Stratagem.DIRECTION.RIGHT:
			arrow.texture = right_arrow_texture
		Stratagem.DIRECTION.DOWN:
			arrow.texture = down_arrow_texture
		Stratagem.DIRECTION.LEFT:
			arrow.texture = left_arrow_texture


func _on_up_button_pressed():
	add_to_input_buffer(Stratagem.DIRECTION.UP)


func _on_down_button_pressed():
	add_to_input_buffer(Stratagem.DIRECTION.DOWN)


func _on_left_button_pressed():
	add_to_input_buffer(Stratagem.DIRECTION.LEFT)


func _on_right_button_pressed():
	add_to_input_buffer(Stratagem.DIRECTION.RIGHT)


func _on_clear_button_pressed():
	input_buffer = []
	clear_stratagem()


func _on_back_button_pressed():
	get_tree().change_scene("res://Scenes/clock.tscn")


func _on_lookup_button_pressed():
	get_tree().change_scene("res://Scenes/lookup.tscn")
