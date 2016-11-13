extends Path2D

var current_wave_index = 0
var current_attacker_index = 0
var timer = 0 #cooldown until next attacker spawn
var waves = [] #parents of the different waves
var attackers = [] #all attackers of the current wave
var spawning = false
var wave_running = false

var active_attackers = []

signal spawning_ended(wave_number)
signal wave_ended(wave_number) 

func _ready():
	set_process(true)
	
	var waves_scene = load("res://Scenes/Maps/Map1Waves.tscn").instance()
	waves = waves_scene.get_children()

func _process(delta):
	if(spawning):
		timer -= delta
		if(timer < 0):
			var new_attacker = attackers[current_attacker_index].duplicate()
			new_attacker.set_pos(Vector2(0, 0))
			self.add_child(new_attacker)
			timer = new_attacker.get_cooldown()
			current_attacker_index+=1
			if(current_attacker_index >= attackers.size()):
				spawning = false
				emit_signal("spawning_ended", current_wave_index-1)
				print("the wave has ended - no more attackers will be spawning")

func add(attacker):
	active_attackers.append(attacker)

func remove(attacker):
	var index = active_attackers.find(attacker)
	if(index != -1):
		active_attackers.remove(index)
	if(active_attackers.size() == 0 and !spawning):
		wave_running = false
		emit_signal("wave_ended", current_wave_index-1)
		print ("the last enemies were defeated, round end")

func start_wave():
	if(!wave_running):
		if(current_wave_index >= waves.size()):
			get_tree().change_scene("res://Scenes/Credits.tscn")
			return
		wave_running = true
		spawning = true
		timer = 0
		current_attacker_index = 0
		attackers = waves[current_wave_index].get_children()
		
		current_wave_index+=1;
	else:
		print("wave already running, please wait for it to end")