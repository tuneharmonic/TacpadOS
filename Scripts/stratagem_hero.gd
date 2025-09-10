class_name StratagemHero extends StratagemReceiver

onready var stratagem_arrow = preload("res://Scenes/stratagem_arrow.tscn")
onready var up_arrow_texture: Texture = preload("res://Textures/Arrows/Up_Arrow.png")
onready var right_arrow_texture: Texture = preload("res://Textures/Arrows/Right_Arrow.png")
onready var down_arrow_texture: Texture = preload("res://Textures/Arrows/Down_Arrow.png")
onready var left_arrow_texture: Texture = preload("res://Textures/Arrows/Left_Arrow.png")

onready var correct1: AudioStream = preload("res://Sounds/correct1.wav")
onready var correct2: AudioStream = preload("res://Sounds/correct2.wav")
onready var correct3: AudioStream = preload("res://Sounds/correct3.wav")
onready var correct4: AudioStream = preload("res://Sounds/correct4.wav")
var correct_sounds: Array

onready var error1: AudioStream = preload("res://Sounds/error1.wav")
onready var error2: AudioStream = preload("res://Sounds/error2.wav")
onready var error3: AudioStream = preload("res://Sounds/error3.wav")
onready var error4: AudioStream = preload("res://Sounds/error4.wav")
var error_sounds: Array

onready var failure_sound: AudioStream = preload("res://Sounds/failurefull.wav")

onready var hit1: AudioStream = preload("res://Sounds/hit1.wav")
onready var hit2: AudioStream = preload("res://Sounds/hit2.wav")
onready var hit3: AudioStream = preload("res://Sounds/hit3.wav")
onready var hit4: AudioStream = preload("res://Sounds/hit4.wav")
var hit_sounds: Array

onready var ready_sound: AudioStream = preload("res://Sounds/ready.wav")

onready var start_sound: AudioStream = preload("res://Sounds/start.wav")

onready var success1: AudioStream = preload("res://Sounds/success1.wav")
onready var success2: AudioStream = preload("res://Sounds/success2.wav")
onready var success3: AudioStream = preload("res://Sounds/success3.wav")
var success_sounds: Array

onready var normal_music: AudioStream = preload("res://Sounds/playing.wav")
onready var special_music: AudioStream = preload("res://Sounds/stratagem_hero.wav")

onready var stratagem_icon: TextureRect = $StratagemPanel/StratagemIcon
onready var stratagem_label: Label = $StratagemPanel/StratagemLabel
onready var stratagem_readout: HBoxContainer = $StratagemPanel/StratagemReadout
onready var timer: Timer = $StratagemPanel/Timer
onready var timer_bar: ColorRect = $StratagemPanel/TimeBarBg/TimeBarContainer/TimeBar
onready var timer_bar_bg: ColorRect = $StratagemPanel/TimeBarBg
onready var round_screen_label: Label = $RoundScreen/Label
onready var animator: AnimationPlayer = $AnimationPlayer
onready var game_over_screen: Panel = $GameOverScreen
onready var game_over_screen_label: Label = $GameOverScreen/Label
onready var score_screen_label: Label = $ScoreScreen/Label
onready var sfx_player: AudioStreamPlayer = $StratagemPanel/SfxPlayer
onready var bgm_player: AudioStreamPlayer = $StratagemPanel/BgmPlayer

export var game_started: bool = false
var timed_out: bool = false
var time_bar_color: Color = Color("d6d7d6")
var max_round_difficulty: int = 5
var initial_time: float = 30.0
var round_time: float
var time_reduction_per_round: float = 4.0
var stratagems_per_round: int = 10
var time_bonus: float
var time_bonus_factor: float = 0.1
var low_time_threshold: float = 0.3
var low_time: bool = false
var current_round: int = 0
var current_round_stratagem: int = 0
var score: int
var round_perfect: bool = true
var round_score: int = 0

var round_stratagems: Array
var input_buffer: Array

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	show_start_screen()
#	stratagems = FileHelper.load_stratagems()
	correct_sounds = [correct1, correct2, correct3, correct4]
	error_sounds = [error1, error2, error3, error4]
	hit_sounds = [hit1, hit2, hit3, hit4]
	success_sounds = [success1, success2, success3]
	#timer.start(initial_time)


func show_start_screen():
	stratagem_icon.hide()
	stratagem_readout.hide()
	timer_bar_bg.hide()
	stratagem_label.text = "Press any direction to start!"

func show_game_screen():
	stratagem_icon.show()
	stratagem_readout.show()
	timer_bar_bg.show()

func start_game():
	current_round = 0
	score = 0
	sfx_player.stream = start_sound
	sfx_player.play()
	start_current_round()
	show_game_screen()

func start_current_round():
	# show "get ready" screen
	round_screen_label.text = "Round %s" % (current_round + 1)
	animator.play("new_round")
	
	var random_stratagems = stratagems.duplicate()
	random_stratagems.shuffle()
	round_stratagems = random_stratagems.slice(0, stratagems_per_round - 1)
	current_round_stratagem = 0
	
	# adjust difficulty per round
	var round_difficulty = clamp(current_round, 0, max_round_difficulty)
	round_time = initial_time - (round_difficulty * time_reduction_per_round)
	time_bonus = round_time * time_bonus_factor
	
	round_perfect = true
	round_score = 0
	
	load_current_stratagem()

func on_new_round_animation_finished():
	timer.start(round_time)
	timed_out = false

func load_current_stratagem():
	var current_stratagem = round_stratagems[current_round_stratagem]
	stratagem_icon.texture = current_stratagem.icon
	clear_stratagem_readout()
	write_stratagem_to_readout(current_stratagem)
	stratagem_label.text = current_stratagem.name


func clear_stratagem_readout():
	for child in stratagem_readout.get_children():
		child.queue_free()

func write_stratagem_to_readout(stratagem: Stratagem):
	for direction in stratagem.code:
		add_arrow_to_readout(direction)

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


func handle_direction_input(direction: int):
	if not game_started:
		start_game()
		game_started = true
	elif not timed_out:
		# test input direction against the next direction in the current stratagem code
		var current_stratagem = round_stratagems[current_round_stratagem]
		var code_position = input_buffer.size()
		
		if current_stratagem.code[code_position] == direction:
			var current_stratagem_arrow = stratagem_readout.get_children()[code_position]
			current_stratagem_arrow.modulate = Color.yellow
			input_buffer.append(direction)
			if input_buffer.size() == current_stratagem.code.size():
				print("yay")
				sfx_player.stream = correct_sounds.pick_random()
				sfx_player.play()
				input_buffer.clear()
				round_score = round_score + 100
				for arrow in stratagem_readout.get_children():
					arrow.modulate = Color.white
				if current_round_stratagem == stratagems_per_round - 1:
					print("next round")
					current_round = current_round + 1
					var perfect_bonus = 0
					if round_perfect:
						perfect_bonus = 100
					var time_bonus_score = round((timer.time_left / round_time) * 100.0)
					print(time_bonus_score)
					timer.stop()
					
					score = score + round_score + perfect_bonus + time_bonus_score
					score_screen_label.text = "Round Score: %s\nPerfect Bonus: %s\nTime Bonus: %s\nTotal Score: %s" % [round_score, perfect_bonus, time_bonus_score, score]
					bgm_player.stop()
					bgm_player.stream = success_sounds.pick_random()
					bgm_player.play()
					animator.play("show_score_screen")
				else:
					current_round_stratagem = current_round_stratagem + 1
					add_time_bonus()
					load_current_stratagem()
			else:
				sfx_player.stream = hit_sounds.pick_random()
				sfx_player.play()
		else:
			round_perfect = false
			input_buffer.clear()
			for arrow in stratagem_readout.get_children():
				arrow.modulate = Color.white
			sfx_player.stream = error_sounds.pick_random()
			sfx_player.play()
			animator.play("wrong_flash")


func add_time_bonus():
	timer.start(clamp(timer.time_left + time_bonus, time_bonus, round_time))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_started:
		var time_left = timer.time_left / round_time
		timer_bar.anchor_right = time_left
		if time_left < low_time_threshold and not low_time:
			timer_bar.color = Color.red
			low_time = true
		if time_left > low_time_threshold and low_time:
			timer_bar.color = time_bar_color
			low_time = false


func _on_up_button_pressed():
	handle_direction_input(Stratagem.DIRECTION.UP)


func _on_down_button_pressed():
	handle_direction_input(Stratagem.DIRECTION.DOWN)


func _on_left_button_pressed():
	handle_direction_input(Stratagem.DIRECTION.LEFT)


func _on_right_button_pressed():
	handle_direction_input(Stratagem.DIRECTION.RIGHT)


func _on_animation_finished(anim_name):
	if anim_name == "new_round":
		on_new_round_animation_finished()
		if current_round < max_round_difficulty:
			bgm_player.stream = normal_music
		else:
			bgm_player.stream = special_music
		bgm_player.play()
	if anim_name == "show_score_screen":
		start_current_round()


func _on_timer_timeout():
	if game_started:
		timed_out = true
		game_started = false
		stratagem_readout.modulate = Color.white
		input_buffer.clear()
		score = score + round_score
		game_over_screen_label.text = "Round Reached: %s\nScore: %s" % [(current_round + 1), score]    # Persist high score
		bgm_player.stop()
		sfx_player.stream = failure_sound
		sfx_player.play()
		animator.play("show_game_over_screen")
		show_start_screen()
		
		


func _on_back_button_pressed():
	emit_signal("load_scene", "res://Scenes/lookup.tscn")
