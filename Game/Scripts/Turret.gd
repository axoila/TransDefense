extends Sprite

export(String, FILE) var item_path = "res://Scenes/BulletTurretItem.tscn"

 # values before calculating secondary slots
export var base_damage = 5.0 # damage per bullet
export var base_rate_of_fire = 1
export var base_max_range = 100
export var base_projectile_speed = 100
export var base_slow = 1.0

 # values after calculating secondary slots
var damage = 0 # damage per bullet
var rate_of_fire = 0
var max_range = 0
var projectile_speed = 0
var slow = 0

var focus_mode = "first"
var focus_on = -1 #index in __attackers_in_range
var turn = true #if the turret should look at the attackers

var __attackers_in_range = []
var __attackers_wr = [] #weakrefs to the attackers so I can check if they're freed or not
var __setup = false

onready var __attacker_path = get_node("/root/Map1/LevelTexture/AttackerPath")

func _ready():
	if !__setup:
		__setup = true
		calc_values()
		get_node("Area2D").connect("area_enter",self,"area_enter")
		set_process(true)
	
func _process(delta):
	# weed out corpses and cowards who run away
	var attacker_index = 0
	while (attacker_index < __attackers_in_range.size()):
		if(__attackers_wr[attacker_index].get_ref() == null || \
				__attackers_in_range[attacker_index].get_global_pos().distance_to(get_global_pos()) > max_range+24):
			__attackers_in_range.remove(attacker_index)
			__attackers_wr.remove(attacker_index)
			focus()
		attacker_index+=1
	
	# turn towards attacker
	if(focus_on > -1):
		if(__attackers_wr[focus_on].get_ref()):
			if(turn):
				set_rot(get_parent().get_angle_to(__attackers_in_range[focus_on].get_global_pos()) + PI)
		else:
			__attackers_in_range.remove(focus_on)
			__attackers_wr.remove(focus_on)
			focus()

func area_enter(area):
	var new_in_range = area.get_parent()
	if(new_in_range.is_in_group("Attacker")):
		__attackers_in_range.append(new_in_range)
		__attackers_wr.append(weakref (__attackers_in_range[__attackers_in_range.size()-1]))
		focus()

func focus():
	focus_on = -1
	if(focus_mode == "first"):
		for attacker_index in range(__attackers_in_range.size()):
#			print(__attackers_in_range)
			if(__attackers_wr[attacker_index].get_ref() != null):
				if(focus_on == -1 || __attackers_in_range[attacker_index].get_offset() > __attackers_in_range[focus_on].get_offset()):
					focus_on = attacker_index

func calc_values():
	damage = base_damage
	rate_of_fire = base_rate_of_fire
	projectile_speed = base_projectile_speed
	max_range = base_max_range
	slow = base_slow
	for slot_index in range(1, 3):
		var item = get_parent().items[slot_index]
		if(item != null):
			damage *= item.get_damage()
			rate_of_fire *= item.get_rate_of_fire()
			projectile_speed *= item.get_projectile_speed()
			max_range *= item.get_max_range()
			slow *= item.get_slow()
	get_node("Area2D/CollisionShape2D").get_shape().set_radius(max_range)