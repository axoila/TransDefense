extends Control

 #exported variables
export(String, FILE) var base_turret = "" #name of the turret

#variables of the modificator
export(float) var damage = 1 setget ,get_damage
export(float) var max_range = 1 setget ,get_max_range
export(float) var projectile_speed = 1 setget ,get_projectile_speed
export(float) var rate_of_fire = 1 setget ,get_rate_of_fire

# variables of the base turret that are somehow important
var base_max_range

var __turret = null

func _ready():
	pass

func get_turret():
	print(base_turret)
	__turret = load(base_turret).instance()
	return __turret #returns the turret which has to be added with add_child(turret)

func get_turret_radius():
	if(__turret == null):
		var tmp_turret = load(base_turret).instance()
		var radius = tmp_turret.base_max_range
		tmp_turret.free()
		return radius
	else:
		return max(__turret.base_max_range, __turret.max_range)

func get_damage():
	return damage

func get_max_range():
	return max_range

func get_projectile_speed():
	return projectile_speed
	
func get_rate_of_fire():
	return rate_of_fire