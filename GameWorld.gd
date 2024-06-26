extends Node2D

var bg1
var bg2
var bgWidth
var bgSpeed = 20  # Speed of the background movement in pixels per second.
var backgroundScene: PackedScene = preload("res://background_tile.tscn")
var pipePairContainer: PackedScene = preload("res://PipePairContainer.tscn")
@onready var pipeTimer: Timer
var pipes
var freeze = true
var score = 0
@onready var scoreLabel = $Score
@onready var gameStartLabel = $GameStartLabel
@onready var deathDialog = $DeathDialog
var gameHasStarted = false
@onready var pipeSpawnTimer = $PipeSpawnTimer

func _ready():
	GlobalSignals.bodyEnteredScoreArea.connect(increaseScore)
	backdropLoad()
	
func increaseScore():
	score += 1
	scoreLabel.text = str(score)

func _process(delta):
	if !freeze or !gameHasStarted:
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
	pipes = get_node("Pipes")
	pipeSpawnTimer.wait_time = 1.75
	pipeSpawnTimer.connect("timeout", spawnPipePair)
	pipeSpawnTimer.start()
		
func spawnPipePair(): 
	pipes.add_child(pipePairContainer.instantiate())
	
func _on_player_player_died():
	freeze = true
	pipeSpawnTimer.paused = true
	deathDialog.add_theme_icon_override("close", Texture2D.new())
	deathDialog.dialog_text = "You jumped through {score} pipes!".format({ "score": score })
	deathDialog.position.x = get_viewport_rect().size.x / 2 - deathDialog.get_size_with_decorations().x / 2 - 15
	deathDialog.position.y = get_viewport_rect().size.y / 2 - 100
	deathDialog.show()

func _on_death_dialog_confirmed():
	get_tree().reload_current_scene()

func _on_death_dialog_canceled():
	get_tree().quit()

func _on_player_game_has_started():
	if !gameHasStarted:
		freeze = false
		scoreLabel.show()
		gameStartLabel.hide()
		pipeHandler()
	gameHasStarted = true
