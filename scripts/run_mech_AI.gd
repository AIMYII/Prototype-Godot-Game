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

func _on_dectection_area_body_entered(body):
	if is_player_in_mech == false:
		if body.is_in_group("Player"):
			body.state = body.RUNNING
			player = body


func _on_dectection_area_body_exited(body):
	if is_player_in_mech == false:
		if body.is_in_group("Player"):
			body.state = body.IDLE
			player = body

func _mech_AI():
	if is_player_in_mech == false:
		# Run AI code, to follow the player, and commands.
		position += (player.position - position) / SPEED
