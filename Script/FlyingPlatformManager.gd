extends Node2D


func _ready():
	$platform1/AnimationPlayer.play("idle")
	$platform2/AnimationPlayer.play("idle")


