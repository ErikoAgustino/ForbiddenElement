extends Node2D

var elementApplied


func _ready():
	$Frozen.visible = false

func ApplyElement(element):
	if(elementApplied != null):
		if(elementApplied == "water" and element == "ice" or elementApplied == "ice" and element == "water"):
			elementApplied = "ice"
			return "frozen"
		elif(elementApplied == "fire" and element == "ice" or element == "fire" and elementApplied == "ice"):
			elementApplied = null
			return "melt"
		elif(elementApplied == "water" and element == "fire" or elementApplied == "fire" and element == "water" ):
			elementApplied = null
			return "vaporize"
		else:
			elementApplied = element
	else:
		elementApplied = element
	$Timer.start(3) 
	return ""

func setFrozen():
	$Frozen.visible = true
	$Frozen/AnimationPlayer.play("frozen")
	
func setUnFrozen():
	$Frozen.visible = false

func _on_Timer_timeout():
	elementApplied = null
