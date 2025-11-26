# ============================================
# Computer
# ============================================
extends Area2D
class_name Computer

@export var computerScreenNode : Node
var alreadyClicked = false

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if (not alreadyClicked):
			_show_dialog('The computer is locked')
			alreadyClicked = true
		else:
			showComputer()
		

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	if dropped_item.item_id == "beakers":
		_show_dialog("I can't short circuit the computer! I need to get into it.")
		# Item stays in inventory (don't remove it)
	else:
		_show_dialog("That can't go on the computer.")

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)

func showComputer():
	print("show computer")
	computerScreenNode.visible = true
