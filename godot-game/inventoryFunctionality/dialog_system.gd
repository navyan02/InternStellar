extends CanvasLayer
class_name DialogSystem

@export var display_time: float = 3.0

@onready var dialog_panel = $Panel
@onready var dialog_label = $Panel/MarginContainer/Label

var timer: Timer

func _ready():
	add_to_group("dialog")
	#dialog_panel.visible = true
	
	# Create timer programmatically
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true

func show_message(text: String, duration: float = -1.0):
	dialog_label.text = text
	dialog_panel.visible = true
	print(text)
	
	var time = duration if duration > 0 else display_time
	timer.start(time)

func _on_timer_timeout():
	dialog_panel.visible = false

func hide_dialog():
	dialog_panel.visible = false
	timer.stop()
