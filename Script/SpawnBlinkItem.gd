extends Node2D


func _ready():
	if(!GlobalMap.getIsSpawnBlink()):
		var blinkItem = load("res://Prefabs/InventoryItems/BlinkItem.tscn").instance()
		var shader = load("res://Prefabs/InventoryItems/ItemShader.tscn").instance()
		var cont = load("res://Prefabs/InventoryItems/FloatingPickableContainer.tscn").instance()
		
		blinkItem.add_child(shader)
		
		cont.add_child(blinkItem)
		cont.setItem(blinkItem)

		cont.setPosition(Vector2(0,0))
		add_child(cont)
