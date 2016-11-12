extends "res://Scripts/Turret.gd"

func _ready():
	._ready() # callparent ready()
	
func _process(delta):
	._process(delta)
	# set laser scale and apply damage
	if(focus_on != -1):
		get_node("Laser").set_scale(Vector2(1, get_global_pos().distance_to(__attackers_in_range[focus_on].get_global_pos())))
		__attackers_in_range[focus_on].damage(damage * delta)
		__attackers_in_range[focus_on].slowed = 2 - slow
	else:
		get_node("Laser").set_scale(Vector2(0, 0))