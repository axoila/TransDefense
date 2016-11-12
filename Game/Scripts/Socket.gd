extends Sprite

var items = [null, null, null]

var turret = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_slot(item, index):
	items[index] = item
	if(index == 0):
		if(item != null):
			turret = item.get_turret()
			add_child(turret)
			turret.set_pos(Vector2(0, 0))
		else:
			remove_child(turret)
			turret.queue_free()
			turret = null
	
	if(turret != null):
		turret.calc_values()

func get_slot(index):
	if(items[index] == null):
		return null
	return items[index]