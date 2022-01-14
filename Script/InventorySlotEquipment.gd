extends Panel


var item
var amount = 0

func _ready():
	item = null
	
func setSlotItem(nama):
	item = nama

func getSlotItem():
	return item
	
func UseSlotItem():
	item.UseItem()
