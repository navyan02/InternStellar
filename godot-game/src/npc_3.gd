# ============================================
# NPC 3
# ============================================
extends Area2D
class_name npc3

var metWithNPC1 = false
var metWithNPC2 = false

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if metWithNPC1 and metWithNPC2:
			_show_dialog("Alright, let's go introduce you")
			await get_tree().create_timer(6.0).timeout
			get_tree().change_scene_to_file("res://src//OpenLvl1/openlvl1.tscn")
		else:
			_show_dialog("Oh Hey! Its weird, your team is normally here by now for coffee.")
			await get_tree().create_timer(5.0).timeout
			_show_dialog("When you're done meeting everyone here in the office, I'll go introduce you!")
			
func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)

func _on_npc_1_interacted_with_npc_1() -> void:
	metWithNPC1 = true

func _on_npc_2_interacted_with_npc_2() -> void:
	metWithNPC2 = true
