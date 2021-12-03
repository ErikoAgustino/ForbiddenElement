tool

extends Area2D

export(String, FILE) var nextScenePath = ""
export(Vector2) var pos
export(bool) var facingRight

var active = true

func _get_configuration_warning() -> String:
	if(nextScenePath == ""):
		return "next scene empty"
	else:
		return ""


func _on_portal_body_entered(body):
	if(body.name == "Player" and active):
		GlobalPlayer.setPos(pos)
		GlobalPlayer.setFacing(facingRight)
		get_tree().change_scene(nextScenePath)

func setIsActive(bol):
	active = bol
	
func getIsActive():
	return active
