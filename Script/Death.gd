extends Control

onready var savePath = "user://save.dat"

func _ready():
	visible = true	
	$HBoxContainer/Revive.grab_focus()


func _on_Revive_pressed():
	var file = File.new()
	var checkOpen = file.open_encrypted_with_pass(savePath, File.READ, "ForbiddenElement")
	if(checkOpen == OK):
		GlobalPlayer.Reset()
		var loadData = file.get_var()
		
		GlobalPlayer.setInventoryItemListPath(loadData["inventoryItem"])
		GlobalPlayer.setInventoryEquipmentListPath(loadData["inventoryEquipment"])
		
		var i = 0
		for x in loadData["currentEquipment"]:
			if(loadData["currentEquipment"][x] != null):
				var inst = load(loadData["currentEquipment"][x]).instance()
				GlobalPlayer.setEquipmentObject(x,inst)
		
		GlobalPlayer.setMaxJump(loadData["maxJump"])
		GlobalPlayer.setIsBlinkActive(loadData["BlinkActive"])	
		GlobalPlayer.setHp(loadData["hp"])
		GlobalPlayer.setPos(loadData["position"])
		
		GlobalMap.setIsSpawnBlink(loadData["MapManager"]["blink"])
		GlobalMap.setIsSpawnDoubleJump(loadData["MapManager"]["doubleJump"])
		GlobalMap.setIsSpawnFlameSword(loadData["MapManager"]["flameSword"])
		GlobalMap.setIsSpawnBossOne(loadData["MapManager"]["bossOne"])
		GlobalMap.setIsSpawnBossTwo(loadData["MapManager"]["bossTwo"])
		
		SoundManager.stop("MenuMusic")
		GlobalMap.PlayMusic()
		get_tree().change_scene(loadData["scene"])
		file.close()
	
func _on_Exit_pressed():
	get_tree().change_scene("res://Scene/Menu.tscn")
	
