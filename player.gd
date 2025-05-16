extends CharacterBody2D

var speed:float = 80
var speed_multiplier = 1

var player_input:Vector2

var weapon_ref := []

var current_weapon: Weapon = null

@export var starting_gun : Weapon

@onready var player_sprite = $sprite
@onready var player_hand = $hand
@onready var player_feet = $feet
@export var player_steps_fx : PackedScene

func _ready() -> void:
	weapon_ref.append(starting_gun)
	await get_tree().process_frame
	pick_up_weapon()

func _process(delta: float) -> void:
	player_input = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	if Input.is_action_just_pressed("pick_up"):
		pick_up_weapon()
	
	if Input.is_action_pressed("fire") and current_weapon != null:
		fire(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	if current_weapon != null:
		aim(get_global_mouse_position())
	move(player_input)
	move_and_slide()

func get_distance(point1 :Vector2, point2: Vector2) -> float:
	var d = point2 - point1
	return sqrt(d.x**2 + d.y**2)

func pick_up_weapon():
	if weapon_ref.size() == 0: return

	var closest_gun : Weapon = get_closest_item(weapon_ref)
	
	if current_weapon != null: 
		current_weapon.reparent(get_tree().current_scene)
	
	
	current_weapon = closest_gun
	current_weapon.rotation = 0
	player_hand.rotation = 0
	weapon_ref.erase(current_weapon)
	
	current_weapon.reparent(player_hand)
	
	current_weapon.global_position = player_hand.global_position

func get_closest_item(list):
	if list.size() == 0: return
	var closest_item: Weapon = list[0]
	var closest_distance: float = get_distance(global_position, list[0].global_position)
	
	for i in list:
		if i != closest_item:
			var d:float = get_distance(global_position, i.global_position)
			if closest_distance > d:
				closest_item = i
				closest_distance = d
	return closest_item

func move(direction: Vector2):
	if direction and player_sprite.animation != "run":
		player_sprite.animation = "run"
	elif direction == Vector2.ZERO:
		if player_sprite.animation != "idle":
			player_sprite.animation = "idle"
	velocity = player_input.normalized() * speed * speed_multiplier

func aim(target: Vector2):
	var flip = target.x < global_position.x
	player_sprite.flip_h = flip
	
	if current_weapon != null:
		current_weapon.sprite.flip_h = flip
	
	var hand_offset = abs(player_hand.position.x)
	player_hand.position.x = hand_offset if flip else -hand_offset
	
	var dif : Vector2 = target - player_hand.global_position
	var target_rotation = dif.normalized().angle()

	var rotation_speed = 15
	player_hand.rotation = lerp_angle(player_hand.rotation, target_rotation, rotation_speed * get_process_delta_time())

func fire(target: Vector2):
	var dir = target - global_position
	var rec := current_weapon.recoil
	if current_weapon.shoot(dir.normalized(), true) and rec != 0:
		handle_recoil(-dir.normalized() * rec)

func handle_recoil(dir: Vector2):
	velocity = dir
	var b = player_steps_fx.instantiate()
	b.global_position = player_feet.global_position
	get_tree().current_scene.add_child(b)
	move_and_slide()
	

func _on_pick_up_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Weapon:
		if area.get_parent() as Weapon != current_weapon:
			weapon_ref.append(area.get_parent() as Weapon)

func weapon_dropped():
	current_weapon = null

func throw():
	pass
	

func _on_pick_up_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Weapon:
		weapon_ref.erase(area.get_parent() as Weapon)
