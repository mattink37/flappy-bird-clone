extends Node2D

func _ready():
	var pipeTimer: Timer = Timer.new()
	add_child(pipeTimer)
	pipeTimer.wait_time = 20
	pipeTimer.connect("timeout", destroy)
	pipeTimer.start()

func destroy():
	self.queue_free()
