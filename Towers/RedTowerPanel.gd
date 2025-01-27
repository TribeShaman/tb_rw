extends Panel

@onready var tower = preload("res://Towers/RedBullet.tscn")
var currTile
var placement_canceled = false
var root 
var validTiles = [
	Vector2i(4,5),
	Vector2i(14,11),
	Vector2i(14,2),
	Vector2i(4,8),
]

func setup_root():
	if get_tree().get_root().get_node("Main") != null:
		root = get_tree().get_root().get_node("Main")
	if get_tree().get_root().get_node("Main2") != null:
		root = get_tree().get_root().get_node("Main2")
	if get_tree().get_root().get_node("Main3") != null:
		root = get_tree().get_root().get_node("Main3")
	if get_tree().get_root().get_node("Main4") != null:
		root = get_tree().get_root().get_node("Main4")
		
func _on_gui_input(event):
	setup_root()
	var cam =  root.get_node("Camera2D")
	if Game.Gold >= 20:
		var tempTower = tower.instantiate()
		if event is InputEventMouseButton and event.button_mask == 1:
			if placement_canceled:
				return
				
			add_child(tempTower)
			tempTower.global_position = cam.get_global_mouse_position()
			#tempTower.process_mode = Node.PROCESS_MODE_DISABLED
			
			tempTower.scale = Vector2(0.32,0.32)
		
		elif event is InputEventMouseMotion and event.button_mask == 1:
			#button left down and dragging
			if get_child_count() > 1:
				
				get_child(1).global_position = event.global_position
				#Check if on Dirt Tile.
				var mapPath =  root.get_node("TileMap")
				var tile = mapPath.local_to_map(cam.get_global_mouse_position())
				currTile = mapPath.get_cell_atlas_coords(0, tile, false)
				var targets = get_child(1).get_node("TowerDetector").get_overlapping_bodies()
				if currTile in validTiles:
					if (targets.size() > 1):
						get_child(1).get_node("Area").modulate = Color(255,255,255)
					else:
						get_child(1).get_node("Area").modulate = Color(0,255,0)
				else:
					
					get_child(1).get_node("Area").modulate = Color(255,255,255)
					
		elif event is InputEventMouseButton and event.button_mask == 3:
			# right click to cancel tower placement
			if get_child_count() > 1:
				get_child(1).queue_free()
				placement_canceled = true
				
		elif event is InputEventMouseButton and event.button_mask == 0:
			#button left release
			if placement_canceled:
				placement_canceled = false
				return
				
			if event.global_position.x >= 3215:
				if get_child_count() > 1:
					get_child(1).queue_free()
			else:
				#check for valid tile:
				if get_child_count() > 1:
					get_child(1).queue_free()
				if currTile in validTiles:
					var targets = []
					if get_child_count() > 1 and is_instance_valid(get_child(1)):
						targets = get_child(1).get_node("TowerDetector").get_overlapping_bodies()
					var path =  root.get_node("Towers")
					if (targets.size() < 2):
						path.add_child(tempTower)
						tempTower.global_position = cam.get_global_mouse_position()
						tempTower.get_node("Area").hide()
						tempTower.startShooting = true
						Game.Gold -= 20
		else:
			if get_child_count() > 1:
				get_child(1).queue_free()
