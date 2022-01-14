extends Sprite

var spriteTexture = preload("res://Texture/capeItem.png")
var description = "+ Damage Reduction"
var is_inUse
var itemPath = "res://Prefabs/InventoryItems/FlyingCape.tscn"
var slotIndex
var equipmentType = "body"

func _ready():
	is_inUse = false

	if(get_parent().name == "Player"):
		visible = false
		GlobalPlayer.connect("rawDamage", self, "OnPlayerGetHit")
		
func UseItem():
	if(!is_inUse):
		setIs_inUse(true)
		GlobalPlayer.setEquipmentObject(equipmentType,getInstance())

func RemoveEquipment():
	if(is_inUse):
		setIs_inUse(false)
		GlobalPlayer.removeEquipmentGlobal(getEquipmentType(), name)

func OnPlayerGetHit(health):
	health -= 3
	if(health < 1):
		GlobalPlayer.minHp(1)
	else:
		GlobalPlayer.minHp(health)

func getSpriteTexture():
	return spriteTexture
	
func getDescription():
	return description
	
func getType():
	return "equipment"
	
func getEquipmentType():
	return equipmentType
	
func getInstance():
	var temp = load(itemPath).instance()
	temp.setSlotIndex(getSlotIndex())
	temp.setIs_inUse(getIs_inUse())
	return temp

func getIs_inUse():
	return is_inUse
	
func setIs_inUse(bol):
	is_inUse = bol

func getItemPath():
	return itemPath
	
func setSlotIndex(index):
	slotIndex = index
	
func getSlotIndex():
	return slotIndex
