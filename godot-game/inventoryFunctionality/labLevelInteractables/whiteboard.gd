# ============================================
# Whiteboard
# ============================================
extends Area2D
class_name Whiteboard

@export var hidden_message: String = "The secret code is: 4815"
var message_revealed: bool = false

@onready var message_label = $MessageLabel  # Add a Label node as child

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)
	if message_label:
		message_label.visible = false
		message_label.text = hidden_message

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if message_revealed:
			_show_dialog(hidden_message)
		else:
			_show_dialog("It's just a blank whiteboard... or is it?")

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	print("*Whiteboard*: Something just dropped on me")
	if dropped_item.item_id == "beakers":
		if not message_revealed:
			_reveal_message()
			inventory.remove_item(dropped_item)
			_show_dialog("The invisible writing is revealed!")
		else:
			_show_dialog("The message is already visible.")
	else:
		_show_dialog("Nothing happens.")

func _reveal_message():
	message_revealed = true
	if message_label:
		message_label.visible = true
	# Could add animation or special effects here

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
