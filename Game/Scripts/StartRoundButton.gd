extends Button

export(String) var attacker_path

func _ready():
	connect("pressed", self, "start")

func start():
	get_node(attacker_path).start_wave()
