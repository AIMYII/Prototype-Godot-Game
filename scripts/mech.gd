extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_player_in_mech = false
var player_in_area = false
var player = null

@export var player_path : NodePath

# State machines
enum {
	IDLE,
	RUNNING,
	PLAYER_GO_IN,
	PLAYER_COME_OUT,
	WAIT
}

var state = IDLE

func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	
	_mech_AI()
	
	match state:
		RUNNING:
			_handle_movement(delta)
	
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta


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

func _on_player_in_mech():
	is_player_in_mech = true


func _on_dectection_area_body_entered(body):
	if body.is_in_group("Player"):
		body.state = body.RUNNING
		player = body


func _on_dectection_area_body_exited(body):
	if body.is_in_group("Player"):
		body.state = body.IDLE
		player = body

func _mech_AI():
	if is_player_in_mech == false:
		# Run AI code, to follow the player, and commands.
		position += (player.position - position) / SPEED
