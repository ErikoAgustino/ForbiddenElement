extends Control

var savePath = "user://save.dat"

func _ready():
	$Transition.FadeOut()
	SoundManager.play_bgm("MenuMusic")
	$VBoxContainer.get_child(0).grab_focus()
	$Confirm.visible = false
	var file = File.new()
	if(file.file_exists(savePath)):
		$VBoxContainer/load.visible = true
	else:
		$VBoxContainer/load.visible = false
	file.close()
	
	
func _on_Start_pressed():
	var file = File.new()
	if(file.file_exists(savePath)):
		$Confirm.visible = true
	else:
		NewFileGame()
		SoundManager.stop("MenuMusic")
		GlobalMap.PlayMusic()
		get_tree().change_scene("res://Scene/v2level0.tscn")
	file.close()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Credits_pressed():
	get_tree().change_scene("res://Scene/Credits.tscn")


func _on_load_pressed():
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


func _on_yes_pressed():
	SoundManager.stop("MenuMusic")
	GlobalMap.PlayMusic()
	get_tree().change_scene("res://Scene/v2level0.tscn")
	NewFileGame()

func NewFileGame():
	var file = File.new()
	
	GlobalPlayer.Reset()
	
	var data = {
	"inventoryItem": [],
	"inventoryEquipment": [], 
	"currentEquipment": {"body":null, "head" :null, "sword":null, "sword2":null},
	"scene": "res://Scene/v2level1.tscn",
	"position": Vector2(100,-100),
	"hp": 100,
	"maxJump": 1,
	"BlinkActive": false,
	"MapManager": {"blink": false, "doubleJump": false, "flameSword" :false, "bossOne": false, "bossTwo": false}
	}
	
	var saveCheck = file.open_encrypted_with_pass(savePath, File.WRITE, "ForbiddenElement")
	if(saveCheck == OK):
		file.store_var(data)
		file.close()	
	
	GlobalMap.setIsSpawnBlink(false)
	GlobalMap.setIsSpawnDoubleJump(false)
	GlobalMap.setIsSpawnFlameSword(false)
	GlobalMap.setIsSpawnBossOne(false)
	GlobalMap.setIsSpawnBossTwo(false)
	
	GlobalPlayer.setInventoryItemListPath([])
	GlobalPlayer.setInventoryEquipmentListPath([])
	GlobalPlayer.setEquipments({"body":null, "head" :null, "sword":null, "sword2":null})
	GlobalPlayer.setHp(100)
	GlobalPlayer.setMaxJump(1)
	GlobalPlayer.setIsBlinkActive(false)
	GlobalPlayer.setPos(Vector2(100,-100))

func _on_no_pressed():
	$Confirm.visible = false
