extends Node2D


func _init():
	if(!GlobalMap.getIsSpawnBossOne()):
		var boss = load("res://Prefabs/Enemy/Wizard.tscn").instance()	
		
		boss.setPosition(Vector2(1500,-160))
		add_child(boss)
