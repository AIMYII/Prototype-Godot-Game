extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_player_in_mech = false

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	_handle_movement(delta)
		
	pass


func _handle_movement(delta):
	if is_player_in_mech == true:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func _mech_AI():
	if is_player_in_mech == false:
		# Run AI code, to follow the player, and commands.
		pass
	pass


func _on_player_in_mech():
	is_player_in_mech = true
