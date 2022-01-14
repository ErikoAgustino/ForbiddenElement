extends Node

signal addEquipment(path)
signal removeEquipment(equipmentName)
signal addInventoryItem(itemPath)
signal addInventoryEquipment(itemPath)
signal rawDamage(hp)
signal DashActive()
signal OnDetectObject(bol)
signal SkillColdDown(cd)

var pos = Vector2()
var facingRight = true
var dialogActive = false
var hp = 100
var maxJump = 1
var isBlinkActive = false
var skillsPath = {}
var skillsList = []
var activeSkill
var equipmentObject = {}
var inventoryList = []
var inventoryEquipmentList = []
var skillCD = 0

func _ready():
	Reset()

	setPos(Vector2(100,-100))
	facingRight = true

	#TestRun
	skillsPath["HolyBall"] = "res://Prefabs/Player/Skills/HolyBall.tscn"
	
	skillsList.append("HolyBall")
	
	activeSkill = 0

func _process(delta):
	if(skillCD > 0):
		setSkillCD(skillCD - delta)

func getSkillCD():
	return skillCD

func setSkillCD(cd):
	skillCD = cd
	emit_signal("SkillColdDown", cd)

func addInventoryEquipmentPath(item):
	inventoryEquipmentList.append(item)
	emit_signal("addInventoryEquipment", item)

func getInventoryEquipmentListPath():
	return inventoryEquipmentList

func setInventoryEquipmentListPath(equipments):
	inventoryEquipmentList = equipments

func addInventoryItemPath(item):
	inventoryList.append(item)
	emit_signal("addInventoryItem", item)

func removeInventoryItemPath(item):
	inventoryList.remove(item)

func getInventoryItemListPath():
	return inventoryList

func setInventoryItemListPath(items):	
	inventoryList = items
	
func setEquipmentObject(key, equipment):
	equipmentObject[key] = equipment
	emit_signal("addEquipment", equipment)

func removeEquipmentGlobal(type, equipmentName):
	equipmentObject[type] = null
	emit_signal("removeEquipment",equipmentName)
	
func getEquipmentObject(key):
	return equipmentObject[key]

func setEquipments(equipment):
	equipmentObject = equipment

func getEquipments():
	var path = {}
	for x in equipmentObject:
		if(equipmentObject[x] != null):
			path[x] = equipmentObject[x].filename
	return path
	
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
	if(hp > 100):
		hp = 100
	
func sendRawDmg(health):
	emit_signal("rawDamage", health)
	
func minHp(health):
	if(getHp() > 0):
		hp -= health
	
func resetHealth():
	hp = 100

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
		
func setIsBlinkActive(blink):
	isBlinkActive = blink
	if(blink):
		emit_signal("DashActive")

func getIsBlinkActive():
	return isBlinkActive
	
func setMaxJump(jump):
	maxJump = jump

func getMaxJump():
	return maxJump

func DetectObject(bol):
	emit_signal("OnDetectObject", bol)

func Reset():
	equipmentObject["head"] = null
	equipmentObject["sword"] = null
	equipmentObject["sword2"] = null
	equipmentObject["body"] = null
	inventoryList = []
	inventoryEquipmentList = []

