extends Node

@export var youWinScreen : Node

var hand_cursor = preload("res://assets/ui/cursorActiveSmall.png")

func change_cursor_hand():
	Input.set_custom_mouse_cursor(hand_cursor)
	
func change_cursor_back():
	Input.set_custom_mouse_cursor(null)
	
# The notepad was opened so lets wait a few seconds then fade in the you win screen
func _on_locked_computer_screen_notepad_was_opened() -> void:
	await get_tree().create_timer(7.0).timeout
	print("You Win")
	var youWinAnim = $"You Win Screen/AnimationPlayer"
	youWinAnim.play("Fade In")
	# The only way I could get the full opacity screen flash to stop was by waiting a short amount of time to make the scene visisble after starting the animation
	await get_tree().create_timer(0.1).timeout
	
	youWinScreen.visible = true
	
	await youWinAnim.animation_finished
	youWinAnim.play("sparkles")
	
	
