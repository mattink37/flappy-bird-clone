extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumpTimer

func _ready():
	jumpTimer = Timer.new()
	add_child(jumpTimer)
	jumpTimer.one_shot = true
	jumpTimer.wait_time = 0.3

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept", true):
		jumpTimer.start()
		set_rotation_degrees(-20)
		velocity.y = JUMP_VELOCITY
		
	simulateBirdFall()
	move_and_slide()
	
func simulateBirdFall():
	var x = 2
	if rotation_degrees > -90 and rotation_degrees < 90 and jumpTimer.is_stopped():
		rotation_degrees += x ** 2
