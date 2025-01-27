extends Node2D


@onready var path = preload("res://Stages/Stage 1.tscn")

func _on_timer_timeout():
	if Game.EnemiesRemaining == 0:
		return
		
	var tempPath = path.instantiate()
	add_child(tempPath)
	Game.EnemiesRemaining -= 1
