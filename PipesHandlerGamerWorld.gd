extends Node2D


func _on_player_player_died():
	for pair in get_children():
		pair.toggleFreeze()
