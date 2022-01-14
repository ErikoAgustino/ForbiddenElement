extends Node2D


func _init():
	if(!GlobalMap.getIsSpawnBossTwo()):
		var boss = load("res://Prefabs/Enemy/EnemyMage.tscn").instance()	
		
		boss.setPosition(Vector2(1100,-180))
		add_child(boss)
