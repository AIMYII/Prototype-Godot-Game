extends CharacterBody2D

# TODO: clean up code.

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_player_in_mech = false # Checks if the player is in the mech 
var player_in_area = false # Might use this for actions, or checks.
var player = null
var follow_player = false;

@export var player_path : NodePath # Allows the player path to be instanced into the code.

# State machines
enum {
	IDLE,
	RUNNING,
	PLAYER_GO_IN,
	PLAYER_COME_OUT,
	WAIT
}

var state = IDLE # Use state machines, later.

func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	if is_player_in_mech == false:
		follow_player == true
		_following_player_mech_AI()
	else:
		follow_player == false
		_mech_AI(delta)
	
	# State machine:
		#match state:
			#RUNNING:
				#_handle_movement(delta)
		
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

# Handles the movement when the player is in the mech.
func _handle_movement(delta):
	if is_player_in_mech == true:
		$dectection_area/CollisionShape2D.disabled = true;
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

# Player signal when the keybind is pressed.
func _on_player_in_mech():
	is_player_in_mech = true

func _on_dectection_area_body_entered(body):
	if is_player_in_mech == false:
		# Safely check in case the mech follows enemies.
		if body == player:
			#body.state = body.RUNNING # State machine/Animation check.
			player = body
			follow_player = true
			player_in_area = true

func _on_dectection_area_body_exited(body):
	if is_player_in_mech == false:
		# Safely check in case the mech follows enemies.
		if body == player:
			#body.state = body.IDLE # State machine/Animation check.
			follow_player = false
			player_in_area = false

func _following_player_mech_AI():
	# Safely check to make sure the player isn't running the animation or presses the keybind.
	if is_player_in_mech == false:
		# Run AI code to follow the player and commands.
		position += (player.position - position) / SPEED

func _mech_AI(delta):
	if is_player_in_mech == true:
		# Stops AI
		_handle_movement(delta);
