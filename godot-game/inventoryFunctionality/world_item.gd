extends Area2D
class_name WorldItem

@export var item_data: ItemData
@export var can_be_picked_up: bool = true

signal clicked(item: WorldItem)
signal item_interacted(dropped_item: ItemData)

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	if item_data and item_data.icon:
		sprite.texture = item_data.icon

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_handle_click()

func _handle_click():
	# Check if we're dragging an item from inventory
	var inventory = get_tree().get_first_node_in_group("inventory")
	if inventory and inventory.get_dragging_item():
		return  # Don't pick up while dragging
	
	if can_be_picked_up and item_data:
		clicked.emit(self)
		_pickup_item()

func _pickup_item():
	var inventory = get_tree().get_first_node_in_group("inventory")
	if inventory and inventory.add_item(item_data):
		_show_dialog(item_data.pickup_dialog)
		if item_data.pickup_sound:
			_play_noise(item_data.pickup_sound)
		queue_free()  # Remove from world

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)

func _play_noise(sound):
	print(sound)
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.stream = sound
	audio_player.play()

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	print("dropped")
	print(ItemData)
	# This method is called when an item is dropped onto this object
	# Override this in specific item scripts for unique interactions
	item_interacted.emit(dropped_item)
	_default_interaction(dropped_item, inventory)

func _default_interaction(dropped_item: ItemData, _inventory: InventorySystem):
	_show_dialog("I can't use " + dropped_item.item_name + " with this.")

func _on_mouse_entered():
	# Visual feedback - could add outline or highlight
	modulate = Color(1.1, 1.1, 1.1)

func _on_mouse_exited():
	modulate = Color(1, 1, 1)
