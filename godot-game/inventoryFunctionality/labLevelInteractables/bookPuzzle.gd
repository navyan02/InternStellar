# ============================================
# Book Puzzle
# ============================================
extends Area2D
class_name BookPuzzle

@export var bookshelf_puzzle_ui: CanvasLayer


func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)
	# Listen for the puzzle being solved
	if bookshelf_puzzle_ui and bookshelf_puzzle_ui.has_signal("puzzle_solved"):
		bookshelf_puzzle_ui.puzzle_solved.connect(_on_bookshelf_puzzle_solved)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if bookshelf_puzzle_ui:
			bookshelf_puzzle_ui.visible = true
		else:
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

func _on_bookshelf_puzzle_solved() -> void:
	# This runs when the big bookshelf puzzle is solved
	print("BookPuzzle: received puzzle_solved signal")
	_show_dialog("The books slide into perfect order. A hidden compartment opens and a small key drops out!")
	# var inv = get_tree().get_first_node_in_group("inventory")
	# if inv:
	# 	inv.add_item("bookshelf_key")
