extends Node

signal addEquipment(path)
signal removeEquipment(equipmentName)
signal addInventoryItem(itemPath)
signal rawDamage(hp)

var pos = Vector2()
var facingRight = true
var dialogActive = false
var hp
var skillsPath = {}
var skillsList = []
var activeSkill
var equipmentObject = {}
var inventoryList = []

func _ready():
	SoundManager.play_se("Sound_0")
	
	#default
	hp = 200

	equipmentObject["head"] = null
	equipmentObject["sword"] = null
	equipmentObject["sword2"] = null
	equipmentObject["body"] = null
	

	setPos(Vector2(100,-100))
	facingRight = true

	#TestRun
	skillsPath["FireBall"] = "res://Prefabs/Player/Skills/FireBall.tscn"
	skillsPath["IceBullet"] = "res://Prefabs/Player/Skills/IceBullet.tscn"
	skillsPath["WaterBall"] = "res://Prefabs/Player/Skills/WaterBall.tscn"
	
	skillsList.append("FireBall")
	skillsList.append("IceBullet")
	skillsList.append("WaterBall")
	
	activeSkill = 0
	
func _process(delta):
	pass
	
func addInventoryItemPath(item):
	inventoryList.append(item)
	emit_signal("addInventoryItem", item)

func getInventoryItemListPath():
	return inventoryList
		
func setEquipmentObject(key, equipment):
	equipmentObject[key] = equipment
	emit_signal("addEquipment", equipment)

func removeEquipmentGlobal(type, equipmentName):
	equipmentObject[type] = null
	emit_signal("removeEquipment",equipmentName)
	
func getEquipmentObject(key):
	return equipmentObject[key]
	
func getAllEquipmentsObject():
	return equipmentObject

func setPos(loc):
	pos = loc
	
func getPos():
	return pos
	
func setFacing(face):
	facingRight = face
	
func getFacing():
	return facingRight
	
func set_is_DialogActive(dialog):
	dialogActive = dialog
	
func get_is_DialogActive():
	return dialogActive
	
func getHp():
	return hp
	
func setHp(health):
	hp = health
	
func addHp(health):
	hp += health
	if(hp > 200):
		hp = 200
	
func sendRawDmg(health):
	emit_signal("rawDamage", health)
	
func minHp(health):
	if(getHp() > 0):
		hp -= health
	
func resetHealth():
	hp = 200

func getActiveSkillPath():
	return skillsPath.get(skillsList[activeSkill])
	
func getActiveSkillIndex():
	return activeSkill
	
func ChangeSkillUp():
	if(activeSkill < len(skillsList) - 1):
		activeSkill += 1
	else:
		activeSkill = 0
		
func ChangeSkillDown():
	if(activeSkill > 0):
		activeSkill -= 1
	else:
		activeSkill = len(skillsList) - 1
