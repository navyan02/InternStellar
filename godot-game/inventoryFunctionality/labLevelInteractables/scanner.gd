# ============================================
# Chemical Scanner
# ============================================
extends Area2D
class_name ChemicalScanner

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("This scanner can analyze chemical compounds.")

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	print("*Scanner*: Something just dropped on me")
	if dropped_item.item_id == "beakers":
		_show_dialog("99% uninvisible ink detected.")
		# Item returns to inventory (don't remove it)
	else:
		_show_dialog("The scanner shows no unusual properties.")

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
