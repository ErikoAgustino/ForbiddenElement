tool

extends Node2D

export (NodePath) var path = ""
var ready = false
var connectNode
var isPush = false

func _get_configuration_warning() -> String:
	if(path == ""):
		return "No Node Path"
	else:
		return ""

func _ready():
	connectNode = get_node(path)

func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		ready = true
		GlobalPlayer.DetectObject(true)


func _on_Area2D_body_exited(body):
	if(body.name == "Player"):
		ready = false
		GlobalPlayer.DetectObject(false)

func _input(event):
	if(ready and Input.is_action_just_pressed("f") and !connectNode.getIsRunning()):
		GlobalPlayer.DetectObject(false)
		if(!isPush):
			$AnimationPlayer.play("push")
			connectNode.SwitchAction()
			isPush = true
		else:
			$AnimationPlayer.play("pull")
			connectNode.SwitchActionR()
			isPush = false
