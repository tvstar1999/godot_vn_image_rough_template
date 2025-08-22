extends Control

onready var rootnode = get_tree().root.get_node("base")
onready var thisnode = sceneload.currentnode

onready var audio_A = rootnode.get_node("AUDIO_A")
onready var audio_B = rootnode.get_node("AUDIO_B")
onready var audio_C = rootnode.get_node("AUDIO_C")
onready var audio_D = rootnode.get_node("AUDIO_D")

var inc1 = 0
var inc2 = 0
var lim = .2
var indx = -1
var loadindx = 0

var switch = false

var texinit = false
var haltinit = false

var isrunning = false

#text
onready var rect = self.get_node("RECT")
#sprite
onready var spr_1 = self.get_node("SPR_1")
onready var spr_2 = self.get_node("SPR_2")

#text
var DLGtex = []
#sprite
var DLGspr_1 = []
var DLGspr_2 = []

#chat voice
var voice = load("res://audio/tone1.wav")

var close_time = 20


func start_dialogue():
	if !isrunning:
		switch = true
		texinit = true


func _process(_delta):
	if switch:
		taktak()
		isrunning = true
	else:
		isrunning = false


func taktak():
	if texinit:
		inc1 = 0
		inc2 = 0
		indx = -1
		loadindx = 0
		
		rect.set_visible_characters(0)
		
		rect.set_text(DLGtex[loadindx])
		spr_1.set_texture(DLGspr_1[loadindx])
		spr_2.set_texture(DLGspr_2[loadindx])
		
		texinit = false
	
	if inc1 > lim:
		#complete typing
		if rect.get_visible_characters() == rect.get_total_character_count():
			if loadindx == DLGtex.size() -1:
				if inc2 > close_time:
					#end function
					sceneload.dialogue_ref = null
					self.get_parent().queue_free()
				else:
					inc2 += .2
			else:
				if Input.is_action_just_pressed("ui_ok"):
					inc1 = 0
					inc2 = 0
					indx = -1
					loadindx += 1
					
					#text
					rect.set_text(DLGtex[loadindx])
					#sprite
					spr_1.set_texture(DLGspr_1[loadindx])
					spr_2.set_texture(DLGspr_2[loadindx])
					
					rect.set_visible_characters(0)
		
		#continue typing
		else:
			if Input.is_action_just_pressed("ui_ok"):
				rect.set_visible_characters(rect.get_total_character_count())
				return
			else:
				inc1 = 0
				indx += 1
				rect.set_visible_characters(indx)
				
				#chat voice
				audio_B.stream = voice
				audio_B.play()
	
	#continue increment and type
	else:
		if Input.is_action_just_pressed("ui_ok"):
			rect.set_visible_characters(rect.get_total_character_count())
			return
		else:
			inc1 += .2

