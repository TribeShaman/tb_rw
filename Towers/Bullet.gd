extends CharacterBody2D


var target
var Speed = 1000
var pathName = ""
var bulletDamage
var timeToLive = 1.0

func _physics_process(delta):
	timeToLive -= delta
	if timeToLive <= 0:
		queue_free()
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")
	var target = null
	
	for i in pathSpawnerNode.get_child_count():
		var path_child = pathSpawnerNode.get_child(i)
		if path_child.name == pathName and path_child.get_child_count() > 0:
			var first_child = path_child.get_child(0)
			if first_child.get_child_count() > 0:
				target = first_child.get_child(0)

	if target and is_instance_valid(target):
		var target_position = target.global_position
		velocity = global_position.direction_to(target_position) * Speed
		look_at(target_position)
		move_and_slide()
	else:
		var screen_size = get_viewport().size  # Get the size of the viewport

		# Check if the bullet is outside the screen
		#if global_position.x < 0 or global_position.y < 0 or global_position.x > screen_size.x or global_position.y > screen_size.y:
			#queue_free()
		#else:
		move_and_slide()

func _on_collision_body_entered(body):
	if "Solider A" in body.name:
		body.Health -= bulletDamage
		queue_free()
		
