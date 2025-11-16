extends Control

@onready var start_btn: Button = %StartBtn
@onready var options_btn: Button = %OptionsBtn
@onready var quit_btn: Button = %QuitBtn
@onready var options_popup: Window = %OptionsPopup
@onready var vol_slider: HSlider = %VolSlider
@onready var subtitle: Label = %Subtitle

var blink_timer := 0.0
var blink_speed := 2.2

func _ready() -> void:
	# Window title
	DisplayServer.window_set_title("InternStellar")
	
	# Focus first button for keyboard users
	start_btn.grab_focus()
	
	# Connect signals
	start_btn.pressed.connect(_on_start_pressed)
	options_btn.pressed.connect(_on_options_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	vol_slider.value_changed.connect(_on_volume_changed)
	%CloseBtn.pressed.connect(func(): options_popup.hide())
	
	# Load saved volume (optional)
	var saved_db := _load_volume_db()
	if saved_db != null:
		vol_slider.value = saved_db
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), float(saved_db))
	else:
		_on_volume_changed(vol_slider.value)

func _process(delta: float) -> void:
	# Blinking "Press Enter to Start"
	blink_timer += delta * blink_speed
	var alpha := 0.55 + 0.45 * 0.5 * (1.0 + sin(blink_timer))
	subtitle.modulate.a = alpha

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_start_pressed()
	elif event.is_action_pressed("ui_cancel"):
		if options_popup.visible:
			options_popup.hide()
		else:
			_on_quit_pressed()

func _on_start_pressed() -> void:
	# Replace with your real main scene path
	var main_scene_path := "res://scenes/Main.tscn"
	if ResourceLoader.exists(main_scene_path):
		get_tree().change_scene_to_file(main_scene_path)
	else:
		# If Main.tscn doesn't exist yet, just print a message.
		print("Main scene not found at ", main_scene_path, ". Create it to continue.")

func _on_options_pressed() -> void:
	options_popup.popup_centered()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_volume_changed(value: float) -> void:
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, value)
	_save_volume_db(value)

func _save_volume_db(db: float) -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load("user://settings.cfg")
	if err != OK:
		# New file is fine
		pass
	cfg.set_value("audio", "master_db", db)
	cfg.save("user://settings.cfg")

func _load_volume_db() -> Variant:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		if cfg.has_section_key("audio", "master_db"):
			return cfg.get_value("audio", "master_db")
	return null
