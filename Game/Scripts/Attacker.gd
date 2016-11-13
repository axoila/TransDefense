extends PathFollow2D

 # editor variables
export var speed = 10 # speed in pixels per second
export var position = 0 # position in pixels
export var cooldown_to_next = 2.0 # tells the attacker spawner how long to wait for the next attacker
export var max_health = 10

 # public variables
var slowed = 1

 # private variables
var __health

func _ready():
	set_process(true)
	get_node("..").add(self)
	__health = max_health
	get_node("ProgressBar").set_max(max_health)
	get_node("ProgressBar").set_val(__health)

func _process(delta):
	if(__health > 0):
		position += speed * delta * slowed
		slowed = 1
		set_offset(position)
		get_node("ProgressBar").set_val(__health)
	else:
		var scale = get_node("AttackerSprite").get_scale().x
		if(scale > 0):
			get_node("AttackerSprite").set_scale(Vector2(scale - delta, scale - delta))
		else:
			get_parent().remove(self)
			self.queue_free()

func get_cooldown():
	return cooldown_to_next

func damage(damage_taken):
	__health-=damage_taken
	if __health <= 0 && has_node("Area2D"):
		var pos = get_global_pos()
		set_pos(pos + Vector2(0, 10000))
		get_node("AttackerSprite").set_global_pos(pos)
		get_node("Area2D").queue_free()
		
		
		