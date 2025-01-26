extends CharacterBody2D


@export var speed = 1000
var Health = 10
var accounted = false

func _physics_process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	
	if get_parent().get_progress_ratio() == 1:
		death()
		if accounted == false:
			Game.EnemiesDown += 1
			Game.Health -= 1
			accounted = true
		
	if Health <= 0:
		death()
		if accounted == false:
			Game.EnemiesDown += 1
			Game.Gold += 1
			accounted = true
	
func death():
	$AnimationPlayer.play("DeathAnimation")
	#get_parent().get_parent().queue_free()
	
