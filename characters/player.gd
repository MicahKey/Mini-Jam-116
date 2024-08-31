extends "res://characters/base_character.gd"

### Variables ###
var ATK_COUNT: int = 1
var SLIDING: bool = false

### Methods ###
func _ready() -> void:
	Global.Player = self
	HP = 3
	SPEED = 600
	JUMP_FORCE = -450
	%SwordHitbox.disabled = true

func attack():
	velocity.x = 0
	ATTACKING = true
	%animation.play('attack_' + str(ATK_COUNT))
	await get_tree().create_timer(0.15).timeout
	%SwordHitbox.disabled = false
	position.x += 5 * LAST_DIR
	

func slide():
	self.set_collision_layer_value(6, false)
	self.set_collision_mask_value(6, false)
	SLIDING = true
	velocity.x = LAST_DIR * SPEED
	%animation.play('slide')

func shift_hitbox(direction):
	%SwordHitbox.position.x = abs(%SwordHitbox.position.x) * direction

func _physics_process(delta: float) -> void:
	# Gravity
	if !is_on_floor():
		apply_gravity(delta)
	
	# Fix hitboxes
	if !ATTACKING:
		%SwordHitbox.disabled = true
	
	if !HIT_STUN:
		# Jump
		if Input.is_action_pressed('jump') && is_on_floor():
			jump()
		
		# Falling and Landing
		if velocity.y > 0 && JUMPING:
			%animation.play('fall')
		
		if velocity.y == 0 && is_on_floor():
			JUMPING = false
		
		# Movement
		var direction:= Input.get_axis('move_left', 'move_right')
		if !ATTACKING && !SLIDING:
			if direction:
				move(direction)
				shift_hitbox(direction)
			else:
				velocity.x = 0
				if !JUMPING:
					%animation.play('idle')
		
		# Sliding
		if Input.is_action_just_pressed('slide') && is_on_floor() && !ATTACKING:
			slide()
		
		# Attacking
		if !ATTACKING && !SLIDING:
			if Input.is_action_pressed('attack') && is_on_floor():
				attack()
			
			# Sprint Attack, Start on spin attack add this later
			#if Input.is_action_pressed('attack') && is_on_floor() && direction:
				#ATK_COUNT = 3
				#attack()
	
	move_and_slide()

### Connects ###
func _on_animation_animation_finished() -> void:
	if %animation.animation == 'hit':
		HIT_STUN = false
	
	elif %animation.animation == 'attack_' + str(ATK_COUNT):
		velocity.x = 0
		%SwordHitbox.disabled = true
		if Input.is_action_pressed('attack') && !HIT_STUN:
			if ATK_COUNT >= 3:
				ATK_COUNT = 0
			ATK_COUNT += 1
			attack()
		else:
			ATTACKING = false
			ATK_COUNT = 1
	
	elif %animation.animation == 'slide':
		SLIDING = false
		self.set_collision_layer_value(6, true)
		self.set_collision_mask_value(6, true)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == 'SwordHitboxArea':
		if HP > 0:
			take_damage()
