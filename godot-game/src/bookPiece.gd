extends Area2D
class_name BookPiece

@export var height_value: int = 1

func _ready() -> void:
	print("BookPiece ready: ", name, "  height_value = ", height_value)
