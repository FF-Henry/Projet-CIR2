extends Control

var speed = 1000
var rotation_speed = 0.3
var direction = Vector2(-1, 0)

@onready var parallax = %ParallaxBackground2
@onready var play = $test/VBoxContainer/play
@onready var back_opt = $Option/BackOpt
@onready var back_odio = $Audio/BackOdio
@onready var back_vdo = $Video/BackVdo
@onready var back_ctrl = $Control/ButtonKey

func _ready():
	play.grab_focus()

func _process(delta):
	parallax.scroll_offset += direction * speed * delta

func show_and_hide(first, second):
	first.show()
	second.hide()
	if first == $test:
		play.grab_focus() 
	elif first == $Option:
		back_opt.grab_focus()
	elif first == $Audio:
		back_odio.grab_focus()
	elif first == $Video:
		back_vdo.grab_focus()
	elif first == $Control:
		back_ctrl.grab_focus()
	#direction = direction.rotated(rotation_speed * delta)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Map/world.tscn")

func _on_quit_pressed():
	get_tree().quit()
	
func _on_option_pressed():
	show_and_hide(%Option, %test)

func _on_video_pressed():
	show_and_hide(%Video, %Option)

func _on_audio_pressed():
	show_and_hide(%Audio, %Option)

func _on_controle_pressed():
	show_and_hide(%Control, %Option)

func _on_back_vdo_pressed():
	show_and_hide(%Option, %Video)

func _on_back_odio_pressed():
	show_and_hide(%Option, %Audio)

func _on_back_opt_pressed():
	show_and_hide(%test, %Option)
	
func _on_button_key_pressed():
	show_and_hide(%Option, %Control)
