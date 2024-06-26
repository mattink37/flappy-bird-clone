extends Node2D

@onready var bottomPipe = $LowerPipe
@onready var topPipe = $UpperPipe
@onready var scoreSound = $ScoreSound
var pipeTimer: Timer
var pipeHeight
var speed: float = 85
var freeze = false

func _ready():
	pipeHeight = topPipe.get_node('PipeSprite').texture.get_height()
	positionPipes()
	pipeTimer = Timer.new()
	add_child(pipeTimer)
	pipeTimer.wait_time = 20
	pipeTimer.connect("timeout", destroy)
	pipeTimer.start()
	
func destroy():
	self.queue_free()

func _process(delta):
	if !freeze:
		position.x -= speed * delta

func toggleFreeze():
	freeze = true
	pipeTimer.paused = true

func positionPipes():
	var vDistBetweenPipes = 125
	topPipe.set_rotation_degrees(180)

	bottomPipe.position.x = 435
	bottomPipe.position.y = randi_range(100, 315)
	
	topPipe.position.x = bottomPipe.position.x
	topPipe.position.y = bottomPipe.position.y - vDistBetweenPipes - pipeHeight
	
	var localScoreShape = SegmentShape2D.new()
	$ScoreArea/CollisionShape2D.shape = localScoreShape
	localScoreShape.a = Vector2(topPipe.position.x, topPipe.position.y)
	localScoreShape.b = Vector2(bottomPipe.position.x, bottomPipe.position.y)


func _on_score_area_body_entered(body):
	if body.is_in_group('Player'):
		GlobalSignals.bodyEnteredScoreArea.emit()
		scoreSound.play()
		
