
extends KinematicBody2D

var target = null
var damage = 0
var speed = 100


var __lifetime

var target_ref = weakref(self)

func _ready():
	set_process(true)
	
	get_node("Area2D").connect("area_enter",self,"collision")

func _process(delta):
	if(!target_ref.get_ref()):
		queue_free()
	else:
		if(target != null):
			set_rot(get_global_pos().angle_to_point(target.get_global_pos()))
			move_local_y(delta * -speed)

func collision(area):
	var new_in_range = area.get_node("..")
	if(new_in_range.is_in_group("Attacker")):
		new_in_range.damage(damage)

func init(target, damage):
	self.target = target
	target_ref = weakref(target)
	self.damage = damage
	__lifetime