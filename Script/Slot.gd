extends Panel


var item
var amount = 0

func _ready():
	item = null
	
func setSlotItem(nama):
	item = nama

	$count.bbcode_enabled = true
	addAmount(1)
		
func addAmount(smItem):
	amount += smItem
	$count.bbcode_text =  str(amount)
	
func minAmount(smItem):
	amount -= smItem
	GlobalPlayer.removeInventoryItemPath(item.getItemPath())
	$count.bbcode_text = str(amount)
	if(amount < 1):
		item = null
		for child in get_children():
			if(child.name != "count"):
				child.queue_free()
				$count.bbcode_text = ""

func getSlotItem():
	return item
	
func UseSlotItem():
	item.UseItem()
	print("glek glek")
