extends Node2D

onready var rootnode = get_tree().root.get_node("base")
onready var thisnode = get_tree().root.get_node("Node2D")

onready var audio_A = rootnode.get_node("AUDIO_A")
onready var audio_B = rootnode.get_node("AUDIO_B")
onready var audio_C = rootnode.get_node("AUDIO_C")
onready var audio_D = rootnode.get_node("AUDIO_D")

var inc = 0
var scene_end = false
var is_running = false

export var wait_time = 2
export var type = -1
export var run = false

#detection wait
var inc_i0 = 0
var lim_i0 = .2

func start_type():
	#so much measurement to prevent sequence skipping lol
	inc_i0 = 0
	
	#release input
	Input.action_release("ui_ok")
	Input.action_release("ui_ok")
	Input.action_release("ui_ok")
	Input.action_release("ui_ok")
	
	#wait
	while inc_i0 < lim_i0:
		yield(get_tree().create_timer(.01), "timeout")
		inc_i0 += .1
	
	if !is_running:
		type += 1
		run = true


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			Input.action_press("ui_ok")
	
	if event is InputEventScreenTouch:
		Input.action_press("ui_ok")


func _process(_delta):
	if Input.is_action_just_pressed("ui_ok") and !is_running:
		start_type()
	
	if run:
		scene()
		run = false


func scene():
	is_running = true
	scene_end = false
	
	audio_C.stream = load("res://audio/twotone.wav")
	audio_C.play()
	
	match type:
		0:
			#main dialogue loading template
			#load node
			sceneload.load_dialogue(true, false)
			
			sceneload.load_dialogue_spr1([load("res://image/placeholder.png"), load("res://image/placeholder.png"), load("res://image/empty.png"), load("res://image/empty.png")])
			sceneload.load_dialogue_spr2([load("res://image/placeholder.png"), load("res://image/empty.png"), load("res://image/placeholder.png"),  load("res://image/empty.png")])
			
			sceneload.load_dialogue_tex(["... test1.\nline break.", "... test2.\nline break.", "... test3.\nline break.", "... test4.\nline break."])
			
			sceneload.load_dialogue_vc(load("res://audio/tone1.wav"))
			
			#start node
			sceneload.load_dialogue(false, true)
			
			#wait until dialogue end
			while true:
				yield(get_tree().create_timer(.01), "timeout")
				
				if sceneload.get_dialogue() == null:
					break
			
			#wait for type sequence
			inc = 0
			while inc < wait_time:
				yield(get_tree().create_timer(.01), "timeout")
				inc += .1
		
		1:
			#fade out
			sceneload.screen_transit_alpha(true, thisnode.get_node("overlay"), Color(1, 1, 1, 1), Color(1, 1, 1, 0), .08)
			
			while true:
				yield(get_tree().create_timer(.01), "timeout")
				if sceneload.screen_transit_end:
					break
			
			#fade audio
			sceneload.audio_transit(true, -80, .02, audio_A)
			
			while true:
				yield(get_tree().create_timer(.01), "timeout")
				
				if sceneload.audio_transit_end:
					break
			
			#end game
			get_tree().quit()
	
	#type end condition
	audio_C.stream = load("res://audio/threetone12.wav")
	audio_C.play()
	
	is_running = false
	scene_end = true

