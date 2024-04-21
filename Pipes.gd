extends Node2D
var freeze = false

func _on_player_player_died():
	for pair in get_children():
		for pipe in pair.get_children():
			pipe.toggleFreeze()
