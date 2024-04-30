extends CharacterBody2D

signal player_died
signal player_scored
signal game_has_started

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animSprite = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumpTimer
var dead = false
var gameHasStarted = false
@onready var jumpSound = $JumpSound
@onready var deathSound = $DeathSound

func _ready():
	jumpTimer = Timer.new()
	add_child(jumpTimer)
	jumpTimer.one_shot = true
	jumpTimer.wait_time = 0.3
 
func _physics_process(delta):
	if not is_on_floor() and gameHasStarted:
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept", true) and !dead:
		gameHasStarted = true
		game_has_started.emit()
		jumpTimer.start()
		set_rotation_degrees(-20)
		velocity.y = JUMP_VELOCITY
		jumpSound.play()
		
	if gameHasStarted:
		simulateBirdFall()
	else:
		position.y = 1 + 10 * sin(3 * position.x)
		print(position.y)
	move_and_slide()
	
func simulateBirdFall():
	var x = 2
	if rotation_degrees > -90 and rotation_degrees < 90 and jumpTimer.is_stopped():
		rotation_degrees += x ** 2

func _on_area_2d_body_entered(body):
	if body.is_in_group('Killer'):
		if !dead:
			deathSound.play()
			animSprite.animation = 'dead'
			player_died.emit()
		dead = true

