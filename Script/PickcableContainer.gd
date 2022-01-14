tool

extends RigidBody2D

export (String) var itemNodeName = ''

var item = null
var ready = false

func _ready():
	add_central_force(Vector2.DOWN)
	if(itemNodeName != ''):
		setItem(get_node(itemNodeName).getInstance())
	
func _input(event):
	if(Input.is_action_just_pressed("f") and ready):
		GlobalPlayer.DetectObject(false)
		if(getItem().getType() == "equipment"):
			GlobalPlayer.addInventoryEquipmentPath(getItem().getItemPath())
		else:
			GlobalPlayer.addInventoryItemPath(getItem().getItemPath())
		queue_free()
	
func setItem(paramItem):
	item = paramItem
	
func getItem():
	return item
	
func setPosition(pos):
	position = pos

func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		ready = true
		GlobalPlayer.DetectObject(true)

func _on_Area2D_body_exited(body):
	if(body.name == "Player"):
		ready = false
		GlobalPlayer.DetectObject(false)
