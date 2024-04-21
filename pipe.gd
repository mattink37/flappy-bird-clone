extends Node2D

var speed: float = 85
var freeze = false

func _ready():
	var pipeTimer: Timer = Timer.new()
	add_child(pipeTimer)
	pipeTimer.wait_time = 20
	pipeTimer.connect("timeout", destroy)
	pipeTimer.start()

func _process(delta):
	if !freeze:
		position.x -= speed * delta

func toggleFreeze():
	freeze = true

func destroy():
	self.queue_free()
