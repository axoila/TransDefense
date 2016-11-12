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

#func _area_enter(area):
#	var new_in_range = area.get_parent()
#	if(new_in_range.is_in_group("Attacker")):
#		__attackers_in_range.append(new_in_range)
#		if(focus_mode == "first"):
#			if(focus_on == null or new_in_range.get_offset() > focus_on.get_offset()):
#				focus_on = new_in_range
#				print(str("mouse over", focus_on))