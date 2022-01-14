extends Control

func _ready():
	visible = false

func TextTransitionActive():
	visible = true
	get_parent().get_node("AndroidControl").visible = false
	$AnimationPlayer.play("TransitionText")

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "TransitionText"):
		ShowText()	
	elif(anim_name == "TransitionOut"):
		get_parent().get_node("AndroidControl").visible = true
		get_parent().get_node("DialogFinal").setActive()
		queue_free()
	
func ShowText():
	$text.bbcode_text = "[center]" + "Natasha show up" +  "[/center]"
	$text.percent_visible = 0
	$Tween.interpolate_property($text, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	SpawnNatasha()
	$AnimationPlayer.play("TransitionOut")
	
	
func SpawnNatasha():
	var natasha = load("res://Prefabs/Player/Natasha.tscn").instance()	
	var jack = get_parent().get_node("../Player")
	var tempPos = jack.getPosition()
	tempPos.y = -150
	if(tempPos.x >= 2610):
		tempPos.x -= 60
	elif(tempPos.x <= 10):
		tempPos.x += 60	
	else:
		if(jack.getFacing()):
			tempPos.x -= 60
		else:
			tempPos.x += 60	
	natasha.flip_h = !jack.getFacing()	
	natasha.position = tempPos
	get_parent().get_parent().add_child(natasha)
	

