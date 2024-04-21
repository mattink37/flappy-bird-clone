extends Node2D
var freeze = false

func _on_player_player_died():
	for child in get_children():
		child.toggleFreeze()
