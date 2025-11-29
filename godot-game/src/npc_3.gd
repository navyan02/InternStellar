# ============================================
# NPC 3
# ============================================
extends Area2D
class_name npc3

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("Oh Hey! Its weird your team is normally your team would be here by now for coffee. Let me go introduce them to you! ")
		await get_tree().create_timer(7.0).timeout
		get_tree().change_scene_to_file("res://src//OpenLvl1/openlvl1.tscn")

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
