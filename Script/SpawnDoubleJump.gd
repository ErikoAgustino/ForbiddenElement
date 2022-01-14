extends Node2D

var once = false

func _ready():
	if(!GlobalMap.getIsSpawnDoubleJump()):
		var doubleJump = load("res://Prefabs/InventoryItems/DoubleJumpItem.tscn").instance()
		var shader = load("res://Prefabs/InventoryItems/ItemShader.tscn").instance()
		var cont = load("res://Prefabs/InventoryItems/FloatingPickableContainer.tscn").instance()
		
		doubleJump.add_child(shader)
		
		cont.add_child(doubleJump)
		cont.setItem(doubleJump)

		cont.setPosition(Vector2(0,0))
		add_child(cont)
		once = true

func _process(delta):
	if(GlobalMap.getIsSpawnDoubleJump() and once):
		once = false
		get_parent().get_node("Canvas/Dialog").setActive()
