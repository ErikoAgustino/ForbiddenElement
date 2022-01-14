tool

extends Control

export(String, FILE, "*.json") var dialogFile

var dialogs = []
var index = 0

func _get_configuration_warning() -> String:
	if(dialogFile == ""):
		return "No Dialog inserted"
	else:
		return ""

func _ready():
	visible = false

func LoadDialog():
	var file = File.new()
	if(file.file_exists(dialogFile)):
		file.open(dialogFile, file.READ)
		return parse_json(file.get_as_text())
	
func setActive():
	visible = true
	GlobalPlayer.set_is_DialogActive(true)
	get_parent().get_node("AndroidControl").visible = false
	index = 0
	dialogs = LoadDialog()
	$DialogBox/next/AnimationPlayer.play("idle")
	ShowDialog()

func _input(event):
	if(Input.is_action_just_pressed("f") and index >= 1 and GlobalPlayer.get_is_DialogActive()):
		$TouchScreenButton.visible = false
		$TimerTouch.start(0.3)
		if($DialogBox/Tween.is_active()):
			SoundManager.stop("blip")
			$DialogBox/Tween.stop_all()
			$DialogBox/DialogText.percent_visible = 100
		else:
			ShowDialog()
	
func ShowDialog():
	if(index < len(dialogs)):
		$DialogBox/NameBox/NameText.text = ""
		$DialogBox/NameBox/NameText.append_bbcode("[center]" + dialogs[index]["name"] + "[/center]")
		$DialogBox/DialogText.bbcode_text = dialogs[index]["dialog"]
		$DialogBox/DialogText.percent_visible = 0
		$DialogBox/Tween.interpolate_property($DialogBox/DialogText, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$DialogBox/Tween.start()
		SoundManager.play_bgs("blip")
		index += 1
	else:
		$Timer.start()

		$DialogBox/next/AnimationPlayer.stop()
		visible = false
		
func _on_Timer_timeout():
	GlobalPlayer.set_is_DialogActive(false)
	get_parent().get_node("AndroidControl").visible = true
	queue_free()

func _on_TimerTouch_timeout():
	$TouchScreenButton.visible = true

func _on_Tween_tween_completed(object, key):
	SoundManager.stop("blip")
