extends Sprite

var spriteTexture = preload("res://Texture/swordItem.png")
var description = "+ Effect Burning Enemy"
var is_inUse
var itemPath = "res://Prefabs/InventoryItems/FlameSword.tscn"
var slotIndex
var equipmentType = "sword"

func _ready():
	is_inUse = false

	if(get_parent().name == "Player"):
		visible = false
		get_parent().get_node("swordHit").connect("body_entered", self, "addBurnEffect")
		
func addBurnEffect(body):
	if(body.has_method("MeleeHitColide")):
		
		for child in body.get_children():
			if(child.name == "Burn"):
				return

		var burn = preload("res://Prefabs/InventoryItems/Burn.tscn").instance()
		body.add_child(burn)

func UseItem():
	if(!is_inUse):
		setIs_inUse(true)
		GlobalPlayer.setEquipmentObject(equipmentType,getInstance())

func RemoveEquipment():
	if(is_inUse):
		setIs_inUse(false)
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
