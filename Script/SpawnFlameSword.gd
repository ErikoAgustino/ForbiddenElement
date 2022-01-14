extends Node2D


func _ready():
	if(!GlobalMap.getIsSpawnFlameSword()):
		var flameSword = load("res://Prefabs/InventoryItems/FlameSword.tscn").instance()
		var cont = load("res://Prefabs/InventoryItems/FloatingPickableContainer.tscn").instance()
		
		cont.add_child(flameSword)
		cont.setItem(flameSword)

		cont.setPosition(Vector2(0,0))
		add_child(cont)
