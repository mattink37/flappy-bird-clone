extends Node2D

var bg1
var bg2
var bgWidth
var bgSpeed = 50  # Speed of the background movement in pixels per second.
var backgroundScene = preload("res://background_tile.tscn")

func _ready():
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
