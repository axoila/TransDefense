extends Control

 #exported variables
export(String) var socket_parent_location = "" # the path to the socket parent
export(NodePath) var socket_radius = 32

 #public variables
onready var socket_parent = get_node(str("/root", socket_parent_location)) # the socket parent node
onready var item_panel_parent = get_node("ScrollContainer/VBoxContainer")
onready var turret_items = [load("res://Scenes/Turrets/LaserTurretItem.tscn"),
	load("res://Scenes/Turrets/BulletTurretItem.tscn"),
	load("res://Scenes/Turrets/TimeTurretItem.tscn"), 
	load("res://Scenes/Elements/SocketItem.tscn")]
var item_shop = [0, 1,  0, 2,  2, 1,  1, 3,   0, 1,  0, 2,  2, 1,  0, 3,   0, 1,  0, 2,  2, 1,  2, 3]

 #private variables
var __selected_socket = null

var __drag_from_socket = null
var __drag_from_socket_index = -1
var __dragged_item = null
var __dragged_item_copy = null

var __drag_socket = false

onready var __socket_inspector = get_node("SocketInspector")

func _ready():
	set_process(true)
	set_process_input(true)
	set_process_unhandled_input(true)
	
	__socket_inspector.connect("slot_released", self, "drop_item_in_inspector")
	__socket_inspector.connect("slot_clicked", self, "drag_item_from_inspector")
	connect("input_event", self, "drop_item_in_toolbar")
	
	socket_parent.get_parent().get_node("AttackerPath").connect("wave_ended", self, "open_upgrades")
	get_node("Panel 2/Panel/HBoxContainer/Button").connect("pressed", self, "upgrade", [get_node("Panel 2/Panel/HBoxContainer/Button")])
	get_node("Panel 2/Panel/HBoxContainer/Button1").connect("pressed", self, "upgrade", [get_node("Panel 2/Panel/HBoxContainer/Button1")])
	
	add_item_in_toolbar(load("res://Scenes/Turrets/LaserTurretItem.tscn").instance())
	
	get_node("Panel 2").hide()

func drag_item_from_panel(event, panel):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if(event.pressed && event.button_index == 1):
			if(panel.get_child_count() > 0 && panel.get_child(0) != null):
				if(__dragged_item_copy != null):
					__dragged_item_copy.queue_free()
				__dragged_item = panel.get_child(0)
				__dragged_item_copy = __dragged_item.duplicate()
				add_child(__dragged_item_copy)
				__dragged_item_copy.set_global_pos(__dragged_item.get_global_pos())
				
				if(__dragged_item.get_turret_radius() != -1):
					__socket_inspector.set_drag(__dragged_item_copy)
					__drag_from_socket = null
					__drag_socket = false
				else:
					__drag_socket = true
	
	if(event.type == InputEvent.MOUSE_MOTION):
		if(panel.get_child(0).get_turret_radius() != -1):
			get_node("Stats").show()
			get_node("Stats").set_global_pos(event.global_pos + Vector2(-192, 0))
			var container = get_node("Stats/VBoxContainer")
			var values = [panel.get_child(0).get_damage(), panel.get_child(0).get_max_range(), panel.get_child(0).get_rate_of_fire(), \
				panel.get_child(0).get_projectile_speed(), panel.get_child(0).get_slow()]
			for container_index in range(container.get_children().size()) :
				if(values[container_index] == 1):
					container.get_child(container_index).hide()
				else:
					container.get_child(container_index).show()
					container.get_child(container_index).get_child(1).set_text(str(floor(values[container_index]*100), "%"))

func drop_item_in_toolbar(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if(!event.pressed && event.button_index == 1):
			if(typeof(__dragged_item) != TYPE_NIL && __dragged_item != null):
				print(__dragged_item_copy)
				
				# delete old stuff
				if(__drag_from_socket == null):
					__dragged_item.get_parent().queue_free()
				else:
					__drag_from_socket.set_slot(null, __drag_from_socket_index)
					__drag_from_socket = null
#					__dragged_item.queue_free()
				__dragged_item = null
				
				#create new panel
				remove_child(__dragged_item_copy)
				add_item_in_toolbar(__dragged_item_copy)
				__dragged_item_copy = null

func drop_item_in_inspector(index):
	if(__drag_socket):
		if(__dragged_item_copy != null):
			__dragged_item_copy.queue_free()
			__dragged_item_copy = null
			__dragged_item = null
			__drag_from_socket = null
			__drag_socket = false
		return
	if(typeof(__dragged_item) != TYPE_NIL && __dragged_item != null && __selected_socket != null):
		if(__drag_from_socket == null):
			__dragged_item.get_parent().queue_free()
		else:
			__drag_from_socket.set_slot(null, __drag_from_socket_index)
			__drag_from_socket = null
		__dragged_item.queue_free()
		__dragged_item = null
		__selected_socket.set_slot(__dragged_item_copy, index)
		remove_child(__dragged_item_copy)
		__socket_inspector.set_slot(__dragged_item_copy, index)
		__dragged_item_copy = null

func drag_item_from_inspector(index):
	var item = __selected_socket.get_slot(index)
	if(item != null):
		if(__dragged_item_copy != null):
			__dragged_item_copy.queue_free()
		__dragged_item = item
		__dragged_item_copy = __dragged_item.duplicate()
		add_child(__dragged_item_copy)
		__socket_inspector.set_drag(__dragged_item_copy)
		__drag_from_socket = __selected_socket
		__drag_from_socket_index = index

func add_item_in_toolbar(item):
	# generate items
	var new_panel = Panel.new()
	get_node("ScrollContainer/VBoxContainer").add_child(new_panel)
	new_panel.set_custom_minimum_size(Vector2(100, 100))
	new_panel.set('custom_styles/panel', load("res://Styling/ItemBox.tres"))
	new_panel.connect("input_event", self, "drag_item_from_panel", [new_panel])
	
	new_panel.add_child(item)
	item.set_pos(Vector2(50, 50))

func open_upgrades(wave):
	get_node("Panel 2").show()
	get_node("Panel 2/Panel/HBoxContainer/Button").get_child(0).queue_free()
	get_node("Panel 2/Panel/HBoxContainer/Button1").get_child(0).queue_free()
	var new_item = turret_items[item_shop[(wave*2)%item_shop.size()]].instance()
	get_node("Panel 2/Panel/HBoxContainer/Button").add_child(new_item)
	new_item.set_pos(Vector2(40, 40))
	new_item = turret_items[item_shop[(wave*2+1)%item_shop.size()]].instance()
	get_node("Panel 2/Panel/HBoxContainer/Button1").add_child(new_item)
	new_item.set_pos(Vector2(40, 40))

func upgrade(button):
	add_item_in_toolbar(button.get_child(0).duplicate())
	get_node("Panel 2").hide()

func _input(event):
	get_node("Stats").hide()
	if(event.type == InputEvent.MOUSE_MOTION):
		if(__dragged_item_copy != null):
			if(__drag_socket):
				__dragged_item_copy.set_global_pos(socket_parent.get_node("../Navigation2D").get_closest_point(event.pos))
			else:
				__dragged_item_copy.set_global_pos(event.pos)
				get_node("Stats").hide()
				__socket_inspector.set_drag(__dragged_item_copy)
		
		for socket in socket_parent.get_children():
			if(socket.get_global_pos().distance_to(event.pos) < socket_radius):
				if(socket != __selected_socket):
					__selected_socket = socket
					__socket_inspector.set_global_pos(socket.get_global_pos())
					__socket_inspector.clear()
					for slot_index in range(0, 3):
						__socket_inspector.set_slot(socket.get_slot(slot_index), slot_index)
			else:
				if(socket == __selected_socket):
					__selected_socket = null
					__socket_inspector.set_global_pos(Vector2(-1000,0))
	
func _unhandled_input(event):
	if(!Input.is_mouse_button_pressed(1)):
		if(__dragged_item_copy != null):
			if(__drag_socket):
				__dragged_item.get_parent().queue_free()
				
				var new_socket = __dragged_item_copy.get_socket()
				socket_parent.add_child(new_socket)
				new_socket.set_global_pos(__dragged_item_copy.get_global_pos())
				__drag_socket = false
				print(new_socket, __dragged_item_copy.get_pos())
			__dragged_item_copy.queue_free()
#			remove_child(__dragged_item_copy)
			__dragged_item_copy = null
			__dragged_item = null
			__drag_from_socket = null
	
	get_node("Stats").hide()