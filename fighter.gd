extends CharacterBody2D

@export_enum("p1_", "p2_") var num: String = "p1_"

const SPEED = 500.0
const JUMP_VELOCITY = -900.0
const accel = 900
const friction = 1000

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(num + "jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	# movement:
	var dir: float = Input.get_axis(num+"left", num+"right")
	if dir != 0:
		velocity.x = SPEED * dir
		#velocity.x = move_toward(velocity.x, SPEED * dir, accel * delta)
		if dir > 0:
			$Sprite/Nose.position = abs($Sprite/Nose.position)
		elif dir < 0:
			$Sprite/Nose.position = abs($Sprite/Nose.position) * -1
	else:
		velocity.x = 0
		#velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	if Input.is_action_pressed(num+"shoot") and %CooldownTimer.is_stopped():
		%CooldownTimer.start()
		const BULLET: PackedScene = preload("uid://ciuw68m2kqgis")
		var bullet: Area2D = BULLET.instantiate()
		%Bullets.add_child(bullet)
		bullet.global_position = %ShootingPoint.global_position
		bullet.dir = 1 if $Sprite/Nose.position.xa > 0 else -1
	
	
	move_and_slide()
