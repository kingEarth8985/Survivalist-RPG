extends CharacterBody2D

const speed = 60
var current_dir = "none"
var default_x = 0
var default_y = 0

var enemy_inrange = false
var enemy_attackcooldown = true
var health = 10
var player_alive = true

var attack_inp = false

func _ready():
	$AnimatedSprite2D.play("front_idle")
	
func update_ghealth(global):
	global.player_health = health

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	update_ghealth(global)
	
	if health <= 0:
		player_alive = false
		health = 0
		print("death")
		self.queue_free()

func player_movement(delta):
	# Reset velocity
	velocity = Vector2.ZERO

	# Handle directional input
	var horizontal_pressed = false
	var vertical_pressed = false

	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		velocity.x += 1
		current_dir = "right"
		horizontal_pressed = true
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		velocity.x -= 1
		current_dir = "left"
		horizontal_pressed = true
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		velocity.y += 1
		if !horizontal_pressed:
			current_dir = "down"
		vertical_pressed = true
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		velocity.y -= 1
		if !horizontal_pressed:
			current_dir = "up"
		vertical_pressed = true

	# Normalize velocity for consistent diagonal speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		play_anim(1, horizontal_pressed, vertical_pressed)
	else:
		play_anim(0, horizontal_pressed, vertical_pressed)

	# Move the character
	move_and_slide()

func play_anim(movement, horizontal, vertical):
	var anim = $AnimatedSprite2D

	if movement == 1:
		if current_dir == "right":
			anim.flip_h = false
			anim.play("side_walk")
		elif current_dir == "left":
			anim.flip_h = true
			anim.play("side_walk")
		elif current_dir == "up":
			anim.flip_h = false
			anim.play("back_walk")
		elif current_dir == "down":
			anim.flip_h = false
			anim.play("front_walk")
	elif movement == 0:
		if attack_inp == false:
			if current_dir == "right" or current_dir == "left":
				anim.flip_h = current_dir == "left"
				anim.play("side_idle")
			elif current_dir == "up":
				anim.flip_h = false
				anim.play("back_idle")
			elif current_dir == "down":
				anim.flip_h = false
				anim.play("front_idle")
				
func player():
	pass

func _on_players_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inrange = true

func _on_players_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inrange = false

func enemy_attack():
	if enemy_inrange and enemy_attackcooldown == true:
		health = health - 1
		enemy_attackcooldown = false
		$cooldown.start()

func _on_cooldown_timeout():
	enemy_attackcooldown = true

func attack():
	var dir =current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_inp = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$attack_cooldown.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$attack_cooldown.start()
		if dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_attack")
			$attack_cooldown.start()
		if dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_attack")
			$attack_cooldown.start()

func _on_attack_cooldown_timeout():
	$attack_cooldown.stop()
	global.player_current_attack = false
	attack_inp = false
