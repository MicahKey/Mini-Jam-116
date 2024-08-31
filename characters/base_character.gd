extends CharacterBody2D

### Variables ###
# Constants
const GRAVITY: float = 900

# Character Variables
var SPEED: float
var JUMP_FORCE: float
var HP: int

# Other Variables
var LAST_DIR = 1

# "States"
var ATTACKING: bool = false
var JUMPING: bool = false
var HIT_STUN: bool = false

### Methods ###
func apply_gravity(delta: float):
	velocity.y += GRAVITY * delta

func take_damage():
	HIT_STUN = true
	HP -= 1
	
	if ATTACKING:
		stop_attack()
	
	velocity.x = 0
	position.x += 10 * LAST_DIR * -1
	
	if HP <= 0:
		death()
	else:
		%animation.play('hit')

func death():
	velocity.y = -200
	%animation.play('death')

func stop_attack():
	%animation.stop
	velocity.x = 0
	if ATTACKING:
		ATTACKING = false

func jump():
	JUMPING = true
	velocity.y = JUMP_FORCE
	%animation.play('jump')

func move(direction: int):
	velocity.x = direction * SPEED
	LAST_DIR = direction
	
	if velocity.x < 0:
		%animation.flip_h = true
	if velocity.x > 0:
		%animation.flip_h = false
	else:
		pass

	if !JUMPING:
		%animation.play('run')

func shift_hitbox(direction):
	%SwordHitbox.position.x = abs(%SwordHitbox.position.x) * direction
	if %HitRange:
		%HitRange.position.x = abs(%HitRange.position.x) * direction

### Connects ###
