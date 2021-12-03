extends Control

const SlotClass = preload("res://Script/Slot.gd")
var selected

func _ready():
	selected = null
	for slot in $GridContainer.get_children():
		slot.connect("gui_input", self, "InventorySlot_Input", [slot])
	
	$sword.connect("gui_input", self, "EquipmentSlot_Input", [$sword])
	$sword2.connect("gui_input", self, "EquipmentSlot_Input", [$sword2])
	$body.connect("gui_input", self, "EquipmentSlot_Input", [$body])
	$head.connect("gui_input", self, "EquipmentSlot_Input", [$head])
	
	LoadInventoryItem()
	LoadEquipments()
	
	GlobalPlayer.connect("addInventoryItem", self, "OnNewItemAdded")
	

func InventorySlot_Input(event: InputEvent, slot: SlotClass):
	if(event is InputEventMouseButton):
		selected = slot

		if(slot.getSlotItem() != null):
			$TextureRect.texture = slot.getSlotItem().getSpriteTexture()
			$Description.text = slot.getSlotItem().getDescription()
			print(slot.getSlotItem().getSlotIndex())
			if(slot.getSlotItem().getType() == "equipment"):
				if(slot.getSlotItem().getIs_inUse()):
					$Button.text = "remove"
				else:
					$Button.text = "use"
			else:
				$Button.text = "use"

func EquipmentSlot_Input(event: InputEvent, slot: SlotClass):
	if(event is InputEventMouseButton):
		selected = slot

		if(slot.getSlotItem() != null):
			$TextureRect.texture = slot.getSlotItem().getSpriteTexture()
			$Description.text = slot.getSlotItem().getDescription()
			$Button.text = "remove"


func _on_Button_pressed():
	if(selected != null and selected.getSlotItem() != null):
		if($Button.text == "use"):
			selected.UseSlotItem()
			
			if(selected.getSlotItem().getType() == "equipment"):
				match(selected.getSlotItem().getEquipmentType()):
					"sword":
						if($sword.get_child_count() < 1):
							$sword.add_child(selected.getSlotItem().getInstance())
							$sword.setSlotItem(selected.getSlotItem().getInstance())
						else:
							$sword.getSlotItem().RemoveEquipment()
							$GridContainer.get_child($sword.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$sword.get_child(0).queue_free()
							$sword.add_child(selected.getSlotItem().getInstance())
							$sword.setSlotItem(selected.getSlotItem().getInstance())
					"sword2":
						if($sword2.get_child_count() < 1):
							$sword2.add_child(selected.getSlotItem().getInstance())
							$sword2.setSlotItem(selected.getSlotItem().getInstance())
						else:
							$sword2.getSlotItem().RemoveEquipment()
							$GridContainer.get_child($sword2.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$sword2.get_child(0).queue_free()
							$sword2.add_child(selected.getSlotItem().getInstance())
							$sword2.setSlotItem(selected.getSlotItem().getInstance())
					"body":
						if($body.get_child_count() < 1):
							$body.add_child(selected.getSlotItem().getInstance())
							$body.setSlotItem(selected.getSlotItem().getInstance())
						else:
							$body.getSlotItem().RemoveEquipment()
							$GridContainer.get_child($body.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$body.get_child(0).queue_free()
							$body.add_child(selected.getSlotItem().getInstance())
							$body.setSlotItem(selected.getSlotItem().getInstance())
					"head":
						if($head.get_child_count() < 1):
							$head.add_child(selected.getSlotItem().getInstance())
							$head.setSlotItem(selected.getSlotItem().getInstance())
						else:
							$head.getSlotItem().RemoveEquipment()
							$GridContainer.get_child($head.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$head.get_child(0).queue_free()
							$head.add_child(selected.getSlotItem().getInstance())
							$head.setSlotItem(selected.getSlotItem().getInstance())
			else:
				var tempIndex = selected.getSlotItem().getSlotIndex()
				print(tempIndex)
				$GridContainer.get_child(tempIndex).minAmount(1)
		
		else:
			selected.getSlotItem().RemoveEquipment()
			$GridContainer.get_child(selected.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
			match(selected.getSlotItem().getEquipmentType()):
					"sword":
						$sword.get_child(0).queue_free()
					"sword2":
						$sword2.get_child(0).queue_free()
					"body":
						$body.get_child(0).queue_free()
					"head":
						$head.get_child(0).queue_free()
		reset()

func _input(event):
	if(Input.is_action_just_pressed("b")):
		if(!visible):
			visible = true
		else:
			visible = false
			
func reset():
	$TextureRect.texture = null
	$Description.text = ""
	$Button.text = "use"
	selected = null

func OnNewItemAdded(itemPath):
	var tempItem = load(itemPath).instance()
	
	
	var itemDuplicateIndex = FindPotionIndex(tempItem.name)
	if(tempItem.getType() == "equipment" or itemDuplicateIndex < 0):
		for x in range($GridContainer.get_child_count()):
			if($GridContainer.get_child(x).getSlotItem() == null):
				tempItem.setSlotIndex(x)
				$GridContainer.get_child(x).add_child(tempItem)
				$GridContainer.get_child(x).setSlotItem(tempItem)
				break
	else:
		$GridContainer.get_child(itemDuplicateIndex).addAmount(1)
				
func FindPotionIndex(itemName):
	for x in range($GridContainer.get_child_count()):
		if($GridContainer.get_child(x).getSlotItem() != null):
			if($GridContainer.get_child(x).getSlotItem().name == itemName):
				return x
	return -1
			
			
			
func LoadInventoryItem():
	var tempInventoryItemList = GlobalPlayer.getInventoryItemListPath()
	if(len(tempInventoryItemList) < 16):
		for x in range(len(tempInventoryItemList)):
			var tempItem = load(tempInventoryItemList[x]).instance()
			if(tempItem.getType() == "equipment"):
				if(GlobalPlayer.getEquipmentObject(tempItem.getEquipmentType()) != null and GlobalPlayer.getEquipmentObject(tempItem.getEquipmentType()).name == tempItem.name):
					tempItem.setSlotIndex(x)
					$GridContainer.get_child(x).add_child(tempItem)
					$GridContainer.get_child(x).setSlotItem(tempItem)
					$GridContainer.get_child(x).getSlotItem().setIs_inUse(true)
				else:
					tempItem.setSlotIndex(x)
					$GridContainer.get_child(x).add_child(tempItem)
					$GridContainer.get_child(x).setSlotItem(tempItem)
			else:
					tempItem.setSlotIndex(x)
					$GridContainer.get_child(x).add_child(tempItem)
					$GridContainer.get_child(x).setSlotItem(tempItem)
		
			
func LoadEquipments():
	if(GlobalPlayer.getEquipmentObject("head") != null):
		$head.add_child(GlobalPlayer.getEquipmentObject("head").getInstance())
		$head.setSlotItem(GlobalPlayer.getEquipmentObject("head").getInstance())
	if(GlobalPlayer.getEquipmentObject("sword") != null):
		$sword.add_child(GlobalPlayer.getEquipmentObject("sword").getInstance())
		$sword.setSlotItem(GlobalPlayer.getEquipmentObject("sword").getInstance())
	if(GlobalPlayer.getEquipmentObject("sword2") != null):
		$sword2.add_child(GlobalPlayer.getEquipmentObject("sword2").getInstance())
		$sword2.setSlotItem(GlobalPlayer.getEquipmentObject("sword2").getInstance())
	if(GlobalPlayer.getEquipmentObject("body") != null):
		$body.add_child(GlobalPlayer.getEquipmentObject("body").getInstance())
		$body.setSlotItem(GlobalPlayer.getEquipmentObject("body").getInstance())
	
			
	
