extends Node2D

@onready var bottomPipe = $LowerPipe
@onready var topPipe = $UpperPipe
var pipeHeight

func _ready():
	pipeHeight = topPipe.get_node('PipeSprite').texture.get_height()
	positionPipes()

func _process(delta):
	pass

func positionPipes():
	var vDistBetweenPipes = 125
	topPipe.set_rotation_degrees(180)

	add_child(bottomPipe)
	bottomPipe.position.x = 550
	bottomPipe.position.y = randi_range(100, 315)
	
	add_child(topPipe)
	topPipe.position.x = bottomPipe.position.x
	topPipe.position.y = bottomPipe.position.y - vDistBetweenPipes - pipeHeight
