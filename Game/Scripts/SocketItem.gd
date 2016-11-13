extends Sprite

export(String, FILE) var socket_path = ""

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func get_turret_radius():
	return -1

func get_socket():
	return load(socket_path).instance()