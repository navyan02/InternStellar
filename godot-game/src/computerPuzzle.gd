extends CanvasLayer


func _on_panel_gui_input(event: InputEvent) -> void:
	print("Event")
	# If the gray background panel is clicked, then we should close the computer. 
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Panel clicked!")
			self.visible = false
