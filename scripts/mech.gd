extends CharacterBody2D

# TODO: clean up code.

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_player_in_mech = false
var player_in_area = false
var player = null
var follow_player = false;

##@onready var Run_AI = preload("res://scripts/run_mech_AI.gd")

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
	if is_player_in_mech == false:
		_mech_AI()
	
	#match state:
		#RUNNING:
			#_handle_movement(delta)
		
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta


func _handle_movement(delta):
	if is_player_in_mech == true:
		#$dectection_area/CollisionShape2D.disabled = true;
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
	#if is_player_in_mech == false:
	## Safely if, in case the mech follows enemies.
	if body == player:
		#if body.is_in_group("Player"):
		#body.state = body.RUNNING
		player = body
		follow_player = true

func _on_dectection_area_body_exited(body):
	#if is_player_in_mech == false:
	if body == player:
		#body.state = body.IDLE
		follow_player = false
		
	#if is_player_in_mech == false:
		#if body.is_in_group("Player"):
			#body.state = body.IDLE
			#player = null

func _mech_AI():
	## Note: This code works.
	if follow_player == true:
		# Run AI code, to follow the player, and commands.
		position += (player.position - position) / SPEED
		
	if is_player_in_mech == true:
		# Stop AI
		#$dectection_area/CollisionShape2D.disabled = true;
		pass
