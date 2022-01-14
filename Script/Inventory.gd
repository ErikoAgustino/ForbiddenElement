extends Control

const SlotClass = preload("res://Script/Slot.gd")
const SlotEquipmentClass = preload("res://Script/InventorySlotEquipment.gd")
var selected

func _ready():
	visible = false
	$EquipmentContainer.visible = true
	$ItemContainer.visible = false
	
	selected = null
	for slot in $EquipmentContainer.get_children():
		slot.connect("gui_input", self, "InventoryEquipmentSlot_Input", [slot])
		
	for slot in $ItemContainer.get_children():
		slot.connect("gui_input", self, "InventoryItemSlot_Input", [slot])
	
	$sword.connect("gui_input", self, "EquipmentSlot_Input", [$sword])
	$sword2.connect("gui_input", self, "EquipmentSlot_Input", [$sword2])
	$body.connect("gui_input", self, "EquipmentSlot_Input", [$body])
	$head.connect("gui_input", self, "EquipmentSlot_Input", [$head])
	
	LoadInventoryItem()
	LoadEquipments()
	LoadInventoryEquipment()
	
	GlobalPlayer.connect("addInventoryItem", self, "OnNewItemAdded")
	GlobalPlayer.connect("addInventoryEquipment",self, "OnNewEquipmentAdded")
	

func InventoryEquipmentSlot_Input(event: InputEvent, slot: SlotEquipmentClass):
	if(event is InputEventMouseButton):
		selected = slot

		if(slot.getSlotItem() != null):
			$TextureRect.texture = slot.getSlotItem().getSpriteTexture()
			$Description.text = slot.getSlotItem().getDescription()
			#print(slot.getSlotItem().getSlotIndex())
			#if(slot.getSlotItem().getType() == "equipment"):
			if(slot.getSlotItem().getIs_inUse()):
				$Button.text = "remove"
			else:
				$Button.text = "use"
				
func InventoryItemSlot_Input(event: InputEvent, slot: SlotClass):
	if(event is InputEventMouseButton):
		selected = slot

		if(slot.getSlotItem() != null):
			$TextureRect.texture = slot.getSlotItem().getSpriteTexture()
			$Description.text = slot.getSlotItem().getDescription()
			$Button.text = "use"


func EquipmentSlot_Input(event: InputEvent, slot: SlotEquipmentClass):
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
							$EquipmentContainer.get_child($sword.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$sword.get_child(0).queue_free()
							$sword.add_child(selected.getSlotItem().getInstance())
							$sword.setSlotItem(selected.getSlotItem().getInstance())
					"sword2":
						if($sword2.get_child_count() < 1):
							$sword2.add_child(selected.getSlotItem().getInstance())
							$sword2.setSlotItem(selected.getSlotItem().getInstance())
						else:
							$sword2.getSlotItem().RemoveEquipment()
							$EquipmentContainer.get_child($sword2.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$sword2.get_child(0).queue_free()
							$sword2.add_child(selected.getSlotItem().getInstance())
							$sword2.setSlotItem(selected.getSlotItem().getInstance())
					"body":
						if($body.get_child_count() < 1):
							$body.add_child(selected.getSlotItem().getInstance())
							$body.setSlotItem(selected.getSlotItem().getInstance())
						else:
							$body.getSlotItem().RemoveEquipment()
							$EquipmentContainer.get_child($body.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$body.get_child(0).queue_free()
							$body.add_child(selected.getSlotItem().getInstance())
							$body.setSlotItem(selected.getSlotItem().getInstance())
					"head":
						if($head.get_child_count() < 1):
							$head.add_child(selected.getSlotItem().getInstance())
							$head.setSlotItem(selected.getSlotItem().getInstance())
						else:
							$head.getSlotItem().RemoveEquipment()
							$EquipmentContainer.get_child($head.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
							$head.get_child(0).queue_free()
							$head.add_child(selected.getSlotItem().getInstance())
							$head.setSlotItem(selected.getSlotItem().getInstance())
			else:
				var tempIndex = selected.getSlotItem().getSlotIndex()
				$ItemContainer.get_child(tempIndex).minAmount(1)
		
		else:
			selected.getSlotItem().RemoveEquipment()
			print(selected.getSlotItem().getSlotIndex())
			$EquipmentContainer.get_child(selected.getSlotItem().getSlotIndex()).getSlotItem().setIs_inUse(false)
			
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

func reset():
	$TextureRect.texture = null
	$Description.text = ""
	$Button.text = "use"
	selected = null

func OnNewItemAdded(itemPath):
	var tempItem = load(itemPath).instance()
	var itemDuplicateIndex = FindPotionIndex(tempItem.name)
	if(itemDuplicateIndex < 0):
		for x in range($ItemContainer.get_child_count()):
			if($ItemContainer.get_child(x).getSlotItem() == null):
				tempItem.setSlotIndex(x)
				$ItemContainer.get_child(x).add_child(tempItem)
				$ItemContainer.get_child(x).setSlotItem(tempItem)
				break
	else:
		$ItemContainer.get_child(itemDuplicateIndex).addAmount(1)
				
func OnNewEquipmentAdded(itemPath):
	var tempItem = load(itemPath).instance()
	for x in range($EquipmentContainer.get_child_count()):
		if($EquipmentContainer.get_child(x).getSlotItem() == null):
			tempItem.setSlotIndex(x)
			$EquipmentContainer.get_child(x).add_child(tempItem)
			$EquipmentContainer.get_child(x).setSlotItem(tempItem)
			break

func FindPotionIndex(itemName):
	for x in range($ItemContainer.get_child_count()):
		if($ItemContainer.get_child(x).getSlotItem() != null):
			if($ItemContainer.get_child(x).getSlotItem().name == itemName):
				return x
	return -1
			
			
			
func LoadInventoryItem():
	var tempInventoryItemList = GlobalPlayer.getInventoryItemListPath()
	var itemIndex = 0
	for x in range(len(tempInventoryItemList)):
		var tempItem = load(tempInventoryItemList[x]).instance()
		var itemDuplicateIndex = FindPotionIndex(tempItem.name)
		if(itemDuplicateIndex < 0):
			tempItem.setSlotIndex(itemIndex)
			$ItemContainer.get_child(itemIndex).add_child(tempItem)
			$ItemContainer.get_child(itemIndex).setSlotItem(tempItem)
			itemIndex += 1
		else:
			$ItemContainer.get_child(itemDuplicateIndex).addAmount(1)
	
func LoadInventoryEquipment():
	var tempInventoryItemList = GlobalPlayer.getInventoryEquipmentListPath()

	for x in range(len(tempInventoryItemList)):
		var tempItem = load(tempInventoryItemList[x]).instance()
		tempItem.setSlotIndex(x)
		$EquipmentContainer.get_child(x).add_child(tempItem)
		$EquipmentContainer.get_child(x).setSlotItem(tempItem)
		if(GlobalPlayer.getEquipmentObject(tempItem.getEquipmentType()) != null and GlobalPlayer.getEquipmentObject(tempItem.getEquipmentType()).name == tempItem.name):
			$EquipmentContainer.get_child(x).getSlotItem().setIs_inUse(true)
			get_node(tempItem.getEquipmentType()).getSlotItem().setSlotIndex(x)
		
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

func _on_equipment_pressed():
	reset()
	$EquipmentContainer.visible = true
	$ItemContainer.visible = false

func _on_potion_pressed():
	reset()
	$EquipmentContainer.visible = false
	$ItemContainer.visible = true

func _input(event):
	if(Input.is_action_just_pressed("b")):
		visible = true
		get_parent().get_node("AndroidControl").visible = false
		get_tree().paused = true

			
func _on_CloseButton_pressed():
	visible = false
	get_parent().get_node("AndroidControl").visible = true
	get_tree().paused = false
