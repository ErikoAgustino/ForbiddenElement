tool

extends Area2D

export(NodePath) var dialog = ""

var ready = false

func _get_configuration_warning() -> String:
	if(dialog == ""):
		return "Dialog empty"
	else:
		return ""

func _ready():
	$keySign.visible = false
	$Sprite/AnimationPlayer.play("idle")
		
func _input(event):
	if(Input.is_action_just_pressed("f") and ready and !GlobalPlayer.get_is_DialogActive()):
		ShowDialog()

func ShowDialog():
	get_node(dialog).setActive()

func _on_Tutor_body_entered(body):
	$keySign/AnimationPlayer.play("idle")
	if(body.name == "Player"):
		ready = true

func _on_Tutor_body_exited(body):
	$keySign/AnimationPlayer.stop()
	$keySign.visible = false
	if(body.name == "Player"):
		ready = false
