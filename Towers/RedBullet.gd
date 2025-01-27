extends StaticBody2D

var Bullet = preload("res://Towers/Bullet.tscn")
var bulletDamage = 5
var pathName
var currTargets = []
var curr

var reload = 0
var range = 300

@onready var timer = get_node("Upgrade/ProgressBar/Timer")
var startShooting = false
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
		

func _process(delta):
	setup_root()
	get_node("Upgrade/ProgressBar").global_position = self.position + Vector2(-64,-81)
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
		if timer.is_stopped():
			Shoot()
			timer.start()
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()
	update_powers()
func Shoot():
	
	var tempBullet = Bullet.instantiate()
	tempBullet.pathName = pathName
	tempBullet.bulletDamage = bulletDamage
	get_node("BulletContainer").add_child(tempBullet)
	tempBullet.global_position = $Aim.global_position
	
	
func _on_tower_body_entered(body):
	if startShooting == false:
		return
		
	if "Solider" in body.name:
		if body not in currTargets:
			currTargets.append(body)
	
	choose_target()

func _on_tower_body_exited(body):
	if startShooting == false:
		return
		
	if body in currTargets:
		currTargets.erase(body)
		
	choose_target()
	
func choose_target():
	if currTargets.size() == 0:
		curr = null
		pathName = null
		return
	
	var currTarget = null
	for i in currTargets:
		if currTarget == null:
			currTarget = i.get_node("../")
		else:
			if i.get_parent().get_progress() > currTarget.get_progress():
				currTarget = i.get_node("../")
				
	curr = currTarget
	pathName = currTarget.get_parent().name
	if timer.paused:
		Shoot()
		timer.paused = false

func _on_range_pressed():
	range += 30
	if Game.Gold >= 20:
		Game.Gold -= 20
		
func _on_attack_speed_pressed():
	if reload <= 1.5:
		
		reload += 0.1
	timer.wait_time = 2 - reload
	if Game.Gold >= 20:
		Game.Gold -= 20
		
func _on_power_pressed():
	bulletDamage += 1
	if Game.Gold >= 20:
		Game.Gold -= 20
		
func _on_timer_timeout():
	Shoot()


func _on_range_mouse_entered():
	get_node("Tower/CollisionShape2D").show()


func _on_range_mouse_exited():
	get_node("Tower/CollisionShape2D").hide()


func update_powers():
	get_node("Upgrade/Upgrade/HBoxContainer/Range/Label").text = str(range)
	get_node("Upgrade/Upgrade/HBoxContainer/Range/Cost").text = str(20)
	get_node("Upgrade/Upgrade/HBoxContainer/AttackSpeed/Label").text = str(2 - reload)
	get_node("Upgrade/Upgrade/HBoxContainer/AttackSpeed/Cost").text = str(20)
	get_node("Upgrade/Upgrade/HBoxContainer/Power/Label").text = str(bulletDamage)
	get_node("Upgrade/Upgrade/HBoxContainer/Power/Cost").text = str(20)
	
	get_node("Tower/CollisionShape2D").shape.radius = range
