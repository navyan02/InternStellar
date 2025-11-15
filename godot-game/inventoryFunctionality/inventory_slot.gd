extends Panel
class_name InventorySlot

signal item_clicked(slot: InventorySlot)
signal drag_started(slot: InventorySlot)

var slot_index: int = 0
var item_data: ItemData = null
var is_dragging: bool = false
var original_position: Vector2

@onready var texture_rect = $TextureRect
@onready var item_icon = $ItemIcon

func _ready():
	texture_rect.visible = false
	gui_input.connect(_on_gui_input)
	original_position = item_icon.position

func set_item(item: ItemData):
	item_data = item
	if item and item.icon:
		item_icon.texture = item.icon
		item_icon.visible = true
	else:
		clear_item()

func clear_item():
	item_data = null
	item_icon.texture = null
	item_icon.visible = false

func set_dragging(dragging: bool):
	is_dragging = dragging
	if dragging:
		item_icon.modulate.a = 0.5
		# Make the icon not block mouse input while dragging
		item_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		item_icon.modulate.a = 1.0
		item_icon.mouse_filter = Control.MOUSE_FILTER_PASS
		# Reset position when done dragging
		item_icon.position = original_position

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if item_data:
					drag_started.emit(self)
			else:
				item_clicked.emit(self)

func _process(_delta):
	if is_dragging and item_data:
		# Move icon to follow mouse, but convert to local coordinates
		var mouse_global = get_global_mouse_position()
		item_icon.global_position = mouse_global - item_icon.size / 2
