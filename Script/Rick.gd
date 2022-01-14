extends AnimatedSprite

var smoke = preload("res://Prefabs/Util/smoke.tscn");

func _ready():
	pass # Replace with function body.

func poofSmoke(pos):
	var smokeBlink = smoke.instance()
	smokeBlink.setPosition(pos)
	get_parent().add_child(smokeBlink)

func Teleport():
	poofSmoke(position)
	queue_free()
