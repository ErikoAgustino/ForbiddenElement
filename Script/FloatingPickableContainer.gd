extends Node2D

export (String) var itemNodeName = ''

var item = null
var ready = false

func _ready():
	if(itemNodeName != ''):
		setItem(get_node(itemNodeName).getInstance())
	
func _input(event):
	if(Input.is_action_just_pressed("f") and ready):
		GlobalPlayer.DetectObject(false)
		if(getItem().getType() == "equipment"):
			GlobalPlayer.addInventoryEquipmentPath(getItem().getItemPath())
			match getItem().name:
				"BlinkItem":
					GlobalMap.setIsSpawnBlink(true)
				"DoubleJumpItem":
					GlobalMap.setIsSpawnDoubleJump(true)
				"FlameSword":
					GlobalMap.setIsSpawnFlameSword(true)
		else:
			GlobalPlayer.addInventoryItemPath(getItem().getItemPath())
		queue_free()
	
func setItem(paramItem):
	item = paramItem
	
func getItem():
	return item
	
func setPosition(pos):
	position = pos

func _on_AreaPick_body_entered(body):
	if(body.name == "Player"):
		ready = true
		GlobalPlayer.DetectObject(true)


func _on_AreaPick_body_exited(body):
	if(body.name == "Player"):
		ready = false
		GlobalPlayer.DetectObject(false)
