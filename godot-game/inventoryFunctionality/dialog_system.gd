extends CanvasLayer
class_name DialogSystem

@export var typewriter_speed: float = 0.03  # seconds per character

@onready var dialog_panel = $Panel
@onready var dialog_label = $Panel/MarginContainer/Label
@onready var audioPlayer = $AudioStreamPlayer2D

var timer: Timer
var typing := false
var full_text := ""
var typing_index := 0

func _ready():
	add_to_group("dialog")
	
	# Create timer programmatically
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
#	Initially hide the dialog.
	hide_dialog()

func show_message(text: String, duration: float = 3.0, playTypingSound: bool = true):
	# Stop any existing timer first to prevent premature hiding
	timer.stop()
	
	full_text = text
	dialog_label.text = ""
	dialog_panel.visible = true
	
	typing = true
	typing_index = 0
	
	# Always stop the audio player attached to the dialog system before playing the next sound
	# Because if we don't stop it, the typewriting could overlap with audio lines potentially
	audioPlayer.stop()
	
	if playTypingSound:
		audioPlayer.play()
		
	_process_typewriter(duration)

func _process_typewriter(duration) -> void:
	if not typing:
		return
	
	if typing_index < full_text.length():
		dialog_label.text = full_text.substr(0, typing_index + 1)
		typing_index += 1
		
		await get_tree().create_timer(typewriter_speed).timeout
		_process_typewriter(duration)
	else:
		# Finished typing - start the display timer
		typing = false
		audioPlayer.stop()
		timer.start(duration)

func _on_timer_timeout():
	hide_dialog()
	

func hide_dialog():
	dialog_panel.visible = false
	timer.stop()
	typing = false
