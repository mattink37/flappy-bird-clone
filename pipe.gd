extends Node2D

var speed: float = 85

func _ready():
	var pipeTimer: Timer = Timer.new()
	add_child(pipeTimer)
	pipeTimer.wait_time = 20
	pipeTimer.connect("timeout", destroy)
	pipeTimer.start()

func _process(delta):
	position.x -= speed * delta

func destroy():
	self.queue_free()
	

