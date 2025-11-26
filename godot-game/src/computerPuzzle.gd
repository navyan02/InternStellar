extends CanvasLayer

@export var passwordField : LineEdit
@export var desktopNode : Node
@export var loginScreen : Node

@onready var audioStreamPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

var startupSound = preload("res://assets/soundEffects/win95.mp3")
var wrongSound = preload("res://assets/soundEffects/wrong.mp3")

func _on_panel_gui_input(event: InputEvent) -> void:
	# If the gray background panel is clicked, then we should close the computer. 
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Panel clicked!")
			self.visible = false

# Login Button
func _on_button_pressed() -> void:
	# On successful login
	if (passwordField.text == "4815"):
		desktopNode.visible = true
		loginScreen.visible = false
		audioStreamPlayer.stream = startupSound
		audioStreamPlayer.play()
	else:
		# Wrong passcode
		audioStreamPlayer.stop()
		audioStreamPlayer.stream = wrongSound
		audioStreamPlayer.play()
