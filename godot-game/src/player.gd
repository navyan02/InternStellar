extends CharacterBody2D

var posToGoTo : Vector2
var speed = 700
var controlMode = "mouse"
# In the future, implement controlMode = "keyboard" for wasd controls.
	
# Get input
# I used _unhandled_input() instead of just _input() so that the inventory has a chance to handle inventory clicks
# This way, only clicks outside of the UI will trigger movement!
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") && controlMode == "mouse":
		posToGoTo = get_global_mouse_position()
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click") && controlMode == "mouse":
		## Convert screen position to world position
		#var mouse_screen_pos = get_viewport().get_mouse_position()
		#var camera = get_viewport().get_camera_2d()
		#
		#if camera:
			## Calculate world position accounting for camera offset
			#posToGoTo = mouse_screen_pos + camera.get_screen_center_position() - get_viewport_rect().size / 2
		#else:
			## Fallback if no camera
			#posToGoTo = mouse_screen_pos
		
#func _physics_process(delta: float) -> void:
	## Calculate direction to target
	#var direction = position.direction_to(posToGoTo)
	#print()
	#print(direction)
	## Set velocity using delta for frame-rate independence
	#velocity = direction * speed
	#
	#if position.distance_to(posToGoTo) > 5:
		#move_and_slide()
		#
		## Check if actually moving based on velocity
		#if abs(velocity.x) < 10 and abs(velocity.y) < 10:
			#$AnimationPlayer.play("player_idle")
		#else:
			#if direction.x > 0.00:
				#$AnimationPlayer.play("player_walk_right")
			#elif direction.x <= 0.00:
				#$AnimationPlayer.play("player_walk_left")
	#else: 
		#velocity = Vector2.ZERO  # Stop moving when reached
		#$AnimationPlayer.play("player_idle")
func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to(posToGoTo) * speed
	
	if global_position.distance_to(posToGoTo) > 5:
		move_and_slide()
		print("Position to go to: ", posToGoTo)
		print("Local Position: ", position)
		print("Global Position: ", global_position)
		print("\n")
		#print(velocity)
		if abs(velocity.x) < 1 and abs(velocity.y) < 1:
			#print("Not Moving")
			$AnimationPlayer.play("player_idle")
		else:
			if global_position.direction_to(posToGoTo)[0] > 0.00:
				#print("right")
				$AnimationPlayer.play("player_walk_right")
			elif global_position.direction_to(posToGoTo)[0] <= 0.00:
				#print("left")
				$AnimationPlayer.play("player_walk_left")
	else: 
		#print("Not moving")
		$AnimationPlayer.play("player_idle")
