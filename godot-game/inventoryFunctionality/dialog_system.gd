extends CanvasLayer
class_name DialogSystem

@export var display_time: float = 3.0
@export var typewriter_speed: float = 0.03  # seconds per character

@onready var dialog_panel = $Panel
@onready var dialog_label = $Panel/MarginContainer/Label

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

func show_message(text: String, duration: float = -1.0):
	full_text = text
	dialog_label.text = ""
	dialog_panel.visible = true
	
	typing = true
	typing_index = 0
	
	# STOP the hide timer. We won't use it.
	timer.stop()
	
	_process_typewriter()

func _process_typewriter() -> void:
	if not typing:
		return
	
	if typing_index < full_text.length():
		dialog_label.text = full_text.substr(0, typing_index + 1)
		typing_index += 1
		
		await get_tree().create_timer(typewriter_speed).timeout
		_process_typewriter()
	else:
		# Finished typing
		typing = false
		# DO NOT start any timer here. Text stays visible until manually hidden.
		pass

func hide_dialog():
	dialog_panel.visible = false
	timer.stop()
	typing = false
