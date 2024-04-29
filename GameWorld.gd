extends Node2D

var bg1
var bg2
var bgWidth
var bgSpeed = 20  # Speed of the background movement in pixels per second.
var backgroundScene: PackedScene = preload("res://background_tile.tscn")
var pipePairContainer: PackedScene = preload("res://PipePairContainer.tscn")
@onready var pipeTimer: Timer
var pipes
var freeze = false
var score = 0
@onready var scoreLabel = $Score
@onready var deathDialog = $DeathDialog

func _ready():
	GlobalSignals.bodyEnteredScoreArea.connect(increaseScore)
	pipeHandler()
	backdropLoad()

func increaseScore():
	score += 1
	scoreLabel.text = str(score)

func _process(delta):
	if !freeze:
		backdropHandler(delta)
	else:
		pipeTimer.stop()
	
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
	pipes = get_node("Pipes")
	pipeTimer = Timer.new()
	add_child(pipeTimer)
	pipeTimer.wait_time = 1.75
	pipeTimer.connect("timeout", spawnPipePair)
	pipeTimer.start()
		
func spawnPipePair(): 
	pipes.add_child(pipePairContainer.instantiate())
	
func _on_player_player_died():
	freeze = true
	deathDialog.add_theme_icon_override("close", Texture2D.new())
	deathDialog.dialog_text = "You jumped through {score} pipes!".format({ "score": score })
	deathDialog.show()

func _on_death_dialog_confirmed():
	get_tree().reload_current_scene()


func _on_death_dialog_canceled():
	get_tree().quit()
