extends Control

func _on_start_button_pressed() -> void:
	print("Start Game")
	get_tree().change_scene_to_file("res://src/OpeningScene/openingscene.tscn")

func _on_exit_pressed() -> void:
	print("Close game")
	get_tree().quit()
