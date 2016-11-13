extends Node

export(String, FILE) var play_scene = "res://Scenes/Maps/Map1.tscn"
export(String, FILE) var credits_scene = ""

#func _ready():
#	current_scene = get_tree().get_current_scene()

func _on_Play_pressed():
	get_tree().change_scene(play_scene)

func _on_Settings_pressed():
	pass # replace with function body

func _on_Credits_pressed():
	get_tree().change_scene(credits_scene)

func _on_Exit_pressed():
	get_tree().quit()