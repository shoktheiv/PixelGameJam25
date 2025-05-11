class_name Weapon extends Node2D

@export var fire_rate: float
var can_attack = true
@export var fireTimer : Timer
@export var shake_duration: float
@export var shake_amount: float
@export var recoil: float
@export var sprite: Sprite2D

func shoot(dir:Vector2, friendly: bool = true) -> bool:
	if can_attack == false: return false
	
	call("attack", dir, friendly)
	can_attack = false
	mainCamera.shake_once(shake_duration, shake_amount)
	if (fireTimer != null):
		reload()
	
	return true

func reload():
	fireTimer.start(fire_rate)
