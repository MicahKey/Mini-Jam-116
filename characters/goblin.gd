extends "res://characters/base_character.gd"
### Variables ###

# "States"
var COOLDOWN: bool = false

### Methods ###
func _ready() -> void:
	HP = 3
	SPEED = 200
	
	%SwordHitbox.disabled = true
	%HealthBar.max_value = HP
	%DamageBar.max_value = HP
	fix_health()
	fix_damage()

func fix_health():
	%HealthBar.value = HP

func fix_damage():
	%DamageBar.value = HP

func attack():
	ATTACKING = true
	velocity.x = 0
	
	%animation.play('attack')
	await get_tree().create_timer(0.25).timeout
	%SwordHitbox.disabled = false

func stop_attack():
	ATTACKING = false
	%SwordHitbox.disabled = true

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		apply_gravity(delta)
	
	# Fix HITBOX
	if !ATTACKING:
		%SwordHitbox.disabled = true
	
	# Notice
	if !ATTACKING && !COOLDOWN && !HIT_STUN:
		# Move Left
		var notice_range = global_position.x - Global.Player.global_position.x
		if notice_range < 500 && notice_range > 0:
			shift_hitbox(-1)
			move(-1)
		# Move Right
		elif notice_range < 0 && notice_range > -500:
			shift_hitbox(1)
			move(1)
		else:
			pass
		
		if !HIT_STUN && !ATTACKING && velocity.x == 0:
			%animation.play('idle')
		
	move_and_slide()

### Connects ###
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == 'SwordHitboxArea':
		if HP > 0 && !HIT_STUN:
			if ATTACKING:
				stop_attack()
			take_damage()
			fix_health()
			%HurtTimer.start()

func _on_animation_animation_finished() -> void:
	if %animation.animation == 'hit':
		HIT_STUN = false
		await get_tree().create_timer(1).timeout
	
	elif %animation.animation == 'attack':
		%SwordHitbox.disabled = true
		%HitRange.disabled = true
		ATTACKING = false
		COOLDOWN = true
		%animation.play('idle')
		await get_tree().create_timer(1).timeout
		COOLDOWN = false
		%HitRange.disabled = false
	
	elif %animation.animation == 'death':
		self.set_collision_layer_value(6, false)
		self.set_collision_mask_value(6, false)
		
		await get_tree().create_timer(2).timeout
		queue_free()


func _on_hit_range_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		if !HIT_STUN:
			attack()


func _on_hurt_timer_timeout() -> void:
	fix_damage()
