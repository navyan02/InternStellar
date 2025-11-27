extends CanvasLayer

signal puzzle_solved

var selected_book: BookPiece = null
@onready var books_row: Node2D = $shelf/BooksRow  # matches your scene tree

func _ready() -> void:
	if books_row == null:
		push_error("BooksRow node not found at path 'shelf/BooksRow'.")
		return

	for child in books_row.get_children():
		if child is BookPiece:
			print("Connecting book (local picking): ", child.name, " local=", child.position)


func _input(event: InputEvent) -> void:
	if !visible:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		var click_pos: Vector2 = event.position
		print("bookshelfPuzzle.gd: got click at (viewport) ", click_pos)

		var clicked_book := _get_book_at_position(click_pos)
		if clicked_book != null:
			print("Hit book: ", clicked_book.name)
			_on_book_clicked(clicked_book)


func _get_book_at_position(viewport_pos: Vector2) -> BookPiece:
	# Convert click into BooksRow's local coordinate space
	var local_pos: Vector2 = books_row.to_local(viewport_pos)
	print("  local to BooksRow: ", local_pos)

	for child in books_row.get_children():
		if child is BookPiece:
			var sprite: Sprite2D = child.get_node_or_null("Sprite2D")
			if sprite and sprite.texture:
				var tex_size: Vector2 = sprite.texture.get_size() * sprite.scale

				# 🔑 Center the rect on the SPRITE, not the BookPiece root
				var sprite_center_local: Vector2 = books_row.to_local(sprite.global_position)
				var rect := Rect2(sprite_center_local - tex_size * 0.5, tex_size)

				# Debug (optional):
				# print("    ", child.name, " rect: ", rect)

				if rect.has_point(local_pos):
					return child

	return null


func _on_book_clicked(book: BookPiece) -> void:
	print("Book clicked in puzzle: ", book.name)

	if selected_book == null:
		# First book selected
		selected_book = book
		print("Selected FIRST book: ", book.name)
	else:
		# If they clicked the same book again, just deselect and do nothing
		if book == selected_book:
			print("Clicked the same book again, cancelling selection")
			selected_book = null
			return

		#Swap the *sprites*' positions, not the root nodes
		var sprite1: Sprite2D = selected_book.get_node("Sprite2D")
		var sprite2: Sprite2D = book.get_node("Sprite2D")

		var p1: Vector2 = sprite1.position
		var p2: Vector2 = sprite2.position

		sprite1.position = p2
		sprite2.position = p1

		print("Swapped ", selected_book.name, " <-> ", book.name)

		selected_book = null

		# Now that the sprites have moved, this will actually change
		if _is_books_in_order():
			print("Books are in correct order!")
			on_bookshelf_puzzle_completed()


func _is_books_in_order() -> bool:
	var books: Array[BookPiece] = []

	# Collect all books
	for child in books_row.get_children():
		if child is BookPiece:
			books.append(child)

	# Sort visually left → right using sprite X
	books.sort_custom(Callable(self, "_sort_books_by_x"))

	# Current visual left→right order of height values
	var values: Array[int] = []
	for book in books:
		values.append(book.height_value)

	# This is the purely sorted order (smallest → largest)
	var sorted_values: Array[int] = values.duplicate()
	sorted_values.sort()

	# Also allow perfectly descending (largest → smallest) if you want
	var sorted_descending: Array[int] = sorted_values.duplicate()
	sorted_descending.reverse()

	print("Current order (by X): ", values, " | Sorted: ", sorted_values)

	#  - either strictly ascending OR strictly descending
	return values == sorted_values or values == sorted_descending



func _sort_books_by_x(a: BookPiece, b: BookPiece) -> bool:
	var sa: Sprite2D = a.get_node_or_null("Sprite2D")
	var sb: Sprite2D = b.get_node_or_null("Sprite2D")
	if sa == null or sb == null:
		return false

	var ax: float = books_row.to_local(sa.global_position).x
	var bx: float = books_row.to_local(sb.global_position).x

	return ax < bx   # a is to the left of b

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		self.visible = false
		
func on_bookshelf_puzzle_completed() -> void:
	print("Bookshelf puzzle SOLVED, emitting puzzle_solved")
	emit_signal("puzzle_solved")
	self.visible = false
