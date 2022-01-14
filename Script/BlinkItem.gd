extends Sprite

var spriteTexture = preload("res://Texture/blinkHat.png")
var description = "+ Blink"
var is_inUse
var itemPath = "res://Prefabs/InventoryItems/BlinkItem.tscn"
var slotIndex
var equipmentType = "head"

func _ready():
	is_inUse = false
	if(get_parent().name == "Player"):
		visible = false
	
func UseItem():
	if(!is_inUse):
		setIs_inUse(true)
		GlobalPlayer.setIsBlinkActive(true)
		GlobalPlayer.setEquipmentObject(equipmentType,getInstance())

func RemoveEquipment():
	if(is_inUse):
		setIs_inUse(false)
		GlobalPlayer.setIsBlinkActive(false)
		GlobalPlayer.removeEquipmentGlobal(getEquipmentType(), name)

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
