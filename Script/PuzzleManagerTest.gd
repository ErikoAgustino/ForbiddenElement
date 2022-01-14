extends Node2D


export (NodePath) var path = ""

var block
var once = true
var once2 = true

func _ready():
	block = get_node(path)
	
func _process(delta):
	if(isAllOn() and once):
		block.SwitchAction()
		once = false
		once2 = true
	elif(once2 and !isAllOn()):
		block.SwitchActionR()
		once2 = false
		once = true
		
func getIsAnimationPlaying():
	return block.getIsRunning()
		
func isAllOn():
	for child in get_children():
		if(!child.getOn()):
			return false
	return true
