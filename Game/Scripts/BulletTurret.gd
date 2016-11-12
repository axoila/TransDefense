extends "res://Scripts/Turret.gd"

var __timer = 0.0

func _ready():
	._ready()
	
func _process(delta):
	._process(delta)
	if(__timer*rate_of_fire < 1):
		__timer += delta
	if(focus_on != -1):
		while(__timer*rate_of_fire >= 1):
			__timer -= 1/rate_of_fire
			
			var new_bullet = get_node("Bullet").duplicate()
			get_parent().add_child(new_bullet)
			new_bullet.init(__attackers_in_range[focus_on], damage)
			new_bullet.speed = projectile_speed
			if(slow != 1):
				new_bullet.mini_stun = true