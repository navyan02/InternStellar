# ============================================
# Key item
# ============================================
extends WorldItem
class_name Key

func _ready():
	super._ready()
	item_data.item_id = "key"
	item_data.item_name = "key"
	item_data.pickup_dialog = "I wonder where I can use this"


func _on_large_book_shelf_puzzle_solved() -> void:
	print("Key saw the puzzle was solved")
	visible = true
