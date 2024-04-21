extends Node2D

var bg1
var bg2
var bgWidth
var bgSpeed = 20  # Speed of the background movement in pixels per second.
var backgroundScene: PackedScene = preload("res://background_tile.tscn")
var pipeScene: PackedScene = preload("res://pipe.tscn")
@onready var pipeTimer: Timer


func _ready():
	pipeHandler()
	backdropLoad()

func _process(delta):
	backdropHandler(delta)
	
func backdropLoad():
	bg1 = backgroundScene.instantiate()
	bg2 = backgroundScene.instantiate()
	bgWidth = bg2.get_node('Sprite2D').texture.get_width()
	bg2.position.x = bgWidth - 1
	
	add_child(bg1)
	add_child(bg2)
		
func backdropHandler(delta):
	bg1.position.x -= delta * bgSpeed
	bg2.position.x -= delta * bgSpeed
	if bg1.position.x < -bgWidth:
		bg1.position.x = bgWidth - 1
	if bg2.position.x < -bgWidth:
		bg2.position.x = bgWidth - 1
		
func pipeHandler():
	var pipeTimer: Timer = Timer.new()
	add_child(pipeTimer)
	pipeTimer.wait_time = 1.75
	pipeTimer.connect("timeout", spawnPipe)
	pipeTimer.start()
		
func spawnPipe():
	var newPipe := pipeScene.instantiate()
	get_node("Pipes").add_child(newPipe)
	newPipe.position.x = 550
	newPipe.position.y = randi_range(100, 380)
