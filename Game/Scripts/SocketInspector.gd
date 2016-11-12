extends Control

signal slot_clicked(index)
signal slot_released(index)

var setup = false

onready var __z_layer = get_node("zLayer")
onready var __slots = [get_node("MainSlot"), get_node("SideSlot1"), get_node("SideSlot2")]
onready var __range_indicator = __z_layer.get_node("RangeIndicator")

func _ready():
	
	if(!setup):
		for slot_index in range(__slots.size()):
			__slots[slot_index].connect("input_event", self, "slot_input",[slot_index])
		
		setup = true

func slot_input(event, index):
	if(event.type == InputEvent.MOUSE_BUTTON && event.button_index == 1):
		if(event.pressed):
			emit_signal("slot_clicked", index)
	
	if(event.type == InputEvent.MOUSE_MOTION):
		if(!Input.is_mouse_button_pressed(1)):
			emit_signal("slot_released", index)

func reparent(new_parent):
	if(new_parent != get_parent()):
		get_parent().remove_child(self)
		new_parent.add_child(self)

func set_slot(item, index):
	if(item != null):
		__slots[index].add_child(item)
		if(index == 0):
			var radius = item.get_turret_radius()
			__range_indicator.set_pos(Vector2(-radius, -radius))
			__range_indicator.set_size(Vector2(radius * 2, radius * 2))
			item.set_scale(Vector2(1, 1))
			item.set_pos(Vector2(16, 16))
		else:
			item.set_scale(Vector2(0.7, 0.7))
			item.set_pos(Vector2(12, 12))

func get_slot(index):
	if(__slots[index].get_child_count() > 0):
		return __slots[index].get_child(0)
	else:
		return null

func set_drag(item):
	if(item != null):
		var radius = item.get_turret_radius()
		__range_indicator.set_pos(Vector2(-radius, -radius))
		__range_indicator.set_size(Vector2(radius * 2, radius * 2))

func clear():
	for slot in __slots:
		for child in slot.get_children():
			child.queue_free()
			slot.remove_child(child)
	__range_indicator.set_size(Vector2(0,0))