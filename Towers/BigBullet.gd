extends CharacterBody2D


var target
var Speed = 500
var pathName = ""
var bulletDamage
var timeToLive = 2.0
var root

func setup_root():
	if get_tree().get_root().get_node("Main") != null:
		root = get_tree().get_root().get_node("Main")
	if get_tree().get_root().get_node("Main2") != null:
		root = get_tree().get_root().get_node("Main2")
	if get_tree().get_root().get_node("Main3") != null:
		root = get_tree().get_root().get_node("Main3")
	if get_tree().get_root().get_node("Main4") != null:
		root = get_tree().get_root().get_node("Main4")

func _ready():
	setup_root()
		
func _physics_process(delta):
	var pathSpawnerNode = root.get_node("PathSpawner")
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
		timeToLive -= delta
		if timeToLive <= 0:
			queue_free()
		move_and_slide()

func _on_collision_body_entered(body):
	if "Soldier" in body.name:
		body.Health -= bulletDamage
		queue_free()
		
