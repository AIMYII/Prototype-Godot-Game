extends CharacterBody2D

# TODO: clean up code.

const SPEED = 900.0
const JUMP_VELOCITY = -400.0

var is_in_mech = false;

signal in_mech;

func _physics_process(delta):
	
	if is_in_mech == false:
		_handle_movement(delta);
	else: 
		pass
	
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		
	if Input.is_action_pressed("go_into_mech"):
		# Wait for player animation going into mech
		is_in_mech = true
		#Timer, maybe?
		emit_signal("in_mech")


func _handle_movement(delta):
	if is_in_mech == false:
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
		
