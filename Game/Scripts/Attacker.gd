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

func _process(delta):
	position += speed * delta * slowed
	slowed = 1
	set_offset(position)

func get_cooldown():
	return cooldown_to_next

func damage(damage_taken):
	__health-=damage_taken
	if __health <= 0:
		get_node("..").remove(self)
		self.queue_free()