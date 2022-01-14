extends Node2D

const carrot = preload("res://Prefabs/InventoryItems/Carrot.tscn")
const redPotion = preload("res://Prefabs/InventoryItems/RedPotion.tscn")
const container = preload("res://Prefabs/InventoryItems/PickcableContainer.tscn")

var spawnItem = true

func _ready():
	visible = false	

func setExplode():
	visible = true
	SoundManager.play_se("explosion")
	$AnimationPlayer.play("explode")
	$Timer.start(0.7)

func _on_Timer_timeout():
	if(get_parent().has_method("Destroy")):
		if(spawnItem):
			DropItem()
		SoundManager.erase_sound("explosion")
		get_parent().Destroy()
		
func DropItem():
	var dropCarrot = round(rand_range(0,3))
	var dropRedPotion = round(rand_range(0,5))

	if(dropCarrot == 0):
		var drop = carrot.instance()
		var cont = container.instance()
		
		cont.add_child(drop)
		cont.setItem(drop)
		cont.setPosition(get_parent().position)
		get_parent().get_parent().add_child(cont)
		
	if(dropRedPotion == 0):
		var drop = redPotion.instance()
		var cont = container.instance()
		
		cont.add_child(drop)
		cont.setItem(drop)
		cont.setPosition(get_parent().position)
		get_parent().get_parent().add_child(cont)

func setSpawnItem(bol):
	spawnItem = bol
