extends Button

export(String, FILE) var scene

func _ready():
	connect("pressed", self, "start")

func start():
	get_tree().change_scene(scene)
