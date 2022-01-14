extends Area2D

var player
var timerLabel = 0
var savePath = "user://save.dat"

func _ready():
	$Label.visible = false
	$AnimationPlayer.play("idle")

func _on_Timer_timeout():
	$Label.visible = false

func _on_CheckPoint_body_entered(body):
	if(body.name == "Player"):
		$AnimationPlayer.play("label")
		$Timer.start(1)
		
		var data = {
			"inventoryItem": GlobalPlayer.getInventoryItemListPath(),
			"inventoryEquipment": GlobalPlayer.getInventoryEquipmentListPath(), 
			"currentEquipment": GlobalPlayer.getEquipments(),
			"scene": get_parent().filename,
			"position": position,
			"hp": GlobalPlayer.getHp(),
			"maxJump": GlobalPlayer.getMaxJump(),
			"BlinkActive": GlobalPlayer.getIsBlinkActive(),
			"MapManager": {"blink": GlobalMap.getIsSpawnBlink(), "doubleJump": GlobalMap.getIsSpawnDoubleJump(), "flameSword" :GlobalMap.getIsSpawnFlameSword(), "bossOne": GlobalMap.getIsSpawnBossOne(), "bossTwo": GlobalMap.getIsSpawnBossTwo()}
		}
		
		var file = File.new()
		var saveCheck = file.open_encrypted_with_pass(savePath, File.WRITE, "ForbiddenElement")
		if(saveCheck == OK):
			file.store_var(data)
			file.close()
			
