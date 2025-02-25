extends StaticBody2D

var Bullet = preload("res://Towers/Bullet.tscn")
var bulletDamage = 10
var pathName = ""
var currTargets = []
var curr = null

var reload = 0
var range = 600

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
		


func _ready():
	setup_root()
	
func _process(delta):
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
		
	if "Soldier" in body.name:
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


func _on_input_event(viewport, event, shape_idx):
	setup_root()
	if event is InputEventMouseButton and event.button_mask == 1:
		var towerPath = root.get_node("Towers")
		for i in towerPath.get_child_count():
			if towerPath.get_child(i).name != self.name:
				towerPath.get_child(i).get_node("Upgrade/Upgrade").hide()
		get_node("Upgrade/Upgrade").visible = !get_node("Upgrade/Upgrade").visible
		get_node("Upgrade/Upgrade").global_position = self.position + Vector2(-572,81)
		

func _on_range_pressed():
	if Game.Gold < 10:
		return
		
	Game.Gold -= 10
	range += 30
		
func _on_attack_speed_pressed():
	if Game.Gold < 10:
		return
		
	if reload >= 1.5:
		return
		
	reload += 0.1
	timer.wait_time = 5 - reload
	Game.Gold -= 10
		
func _on_power_pressed():
	if Game.Gold < 10:
		return
		
	bulletDamage += 1
	Game.Gold -= 10
		
func _on_timer_timeout():
	if curr != null:
		Shoot()
	else:
		timer.paused = true


func _on_range_mouse_entered():
	get_node("Tower/CollisionShape2D").show()


func _on_range_mouse_exited():
	get_node("Tower/CollisionShape2D").hide()


func update_powers():
	get_node("Upgrade/Upgrade/HBoxContainer/Range/Label").text = str(range)
	get_node("Upgrade/Upgrade/HBoxContainer/Range/Cost").text = str(10)
	get_node("Upgrade/Upgrade/HBoxContainer/AttackSpeed/Label").text = str(5 - reload)
	get_node("Upgrade/Upgrade/HBoxContainer/AttackSpeed/Cost").text = str(10)
	get_node("Upgrade/Upgrade/HBoxContainer/Power/Label").text = str(bulletDamage)
	get_node("Upgrade/Upgrade/HBoxContainer/Power/Cost").text = str(10)
	
	get_node("Tower/CollisionShape2D").shape.radius = range
