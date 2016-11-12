extends "res://Scripts/Turret.gd"

export(String, FILE) var field_particle = ""

var active = true
onready var time_field = get_node("TimeField")

var __particle_frequency = 1
var __timer = 0
var __particle_amount = 16

func _ready():
	._ready() # callparent ready()
	turn = false
	
func _process(delta):
	._process(delta)
	 # slow all enemies in range
	if(focus_on != -1):
		for attacker in __attackers_in_range:
			attacker.slowed = 1.0 - damage * slow
		
		if(!active):
			var size = (2.0 * max_range) / time_field.get_texture().get_height()
			time_field.set_scale(Vector2(size, size))
			get_node("TimeField/Particles2D").set_amount(__particle_amount)
			active = true
	else:
		if(active):
			time_field.set_scale(Vector2(0, 0))
			get_node("TimeField/Particles2D").set_amount(0)
			active = false

func calc_values():
	.calc_values()
	var time_field = get_node("TimeField")
	var size = (2.0 * max_range) / time_field.get_texture().get_height()
	time_field.set_scale(Vector2(size, size))