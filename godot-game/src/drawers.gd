# ============================================
# Chemical Scanner
# ============================================
extends Area2D
class_name DeskDrawers

var unlocked = false

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if unlocked:
			_show_dialog("Its filled with files. They all seem to be confidential information on... aliens?", 4.0)
		else:
			_show_dialog("The drawers are locked", 4.0)

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	#$AnimationPlayer.play("scanUp")
	#$AudioStreamPlayer2D.play(4.5)
	#await $AnimationPlayer.animation_finished
	#$AudioStreamPlayer2D.stop()
	
	if dropped_item.item_id == "key":
		_show_dialog("It unlocked!", 4.0)
		inventory.remove_item(dropped_item)
		unlocked = true
	else:
		_show_dialog("It's locked", 5.0)

func _show_dialog(text: String, howLong: float):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text, howLong)
	else:
		print("Dialog: ", text)
