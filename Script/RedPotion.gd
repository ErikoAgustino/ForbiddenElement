extends Sprite


var hp
var spriteTexture = preload("res://Texture/redPotion3.png")
var description 
var itemPath = "res://Prefabs/InventoryItems/RedPotion.tscn"
var slotIndex

func _ready():
	description = "Red potion + hp 50"
	hp = 50
	
func UseItem():
	GlobalPlayer.addHp(hp)

func getSpriteTexture():
	return spriteTexture
	
func getDescription():
	return description
	
func getType():
	return "potion"
	
func getInstance():
	var temp = load(itemPath).instance()
	temp.setSlotIndex(getSlotIndex())
	return temp

func getItemPath():
	return itemPath
	
func setSlotIndex(index):
	slotIndex = index
	
func getSlotIndex():
	return slotIndex

