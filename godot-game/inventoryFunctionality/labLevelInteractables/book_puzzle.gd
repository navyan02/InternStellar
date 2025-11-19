# ============================================
# Book Puzzle
# ============================================
extends Area2D
class_name BookPuzzle

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("This shelf is kind of disorganized")

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	if dropped_item.item_id == "beakers":
		_show_dialog("Whoops! Almost spilled the chemicals on the books!")
		# Item stays in inventory (don't remove it)
	else:
		_show_dialog("I better not put this on the shelf, its disorganized enough.")

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
