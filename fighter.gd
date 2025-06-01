extends CharacterBody2D

@export_enum("p1_", "p2_") var num: String = "p1_"

var speed: float = 500.0
var jump_force: float = -900.0
var accel = 900
var friction = 1000

var health: int = 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(num + "jump") and is_on_floor():
		velocity.y = jump_force
	
	
	# movement:
	var dir: float = Input.get_axis(num+"left", num+"right")
	if dir != 0:
		velocity.x = speed * dir
		#velocity.x = move_toward(velocity.x, speed * dir, accel * delta)
		if dir > 0:
			%Nose.position.x = 46.0
			%ShootingPoint.position.x = 72.0
		elif dir < 0:
			%Nose.position.x = -46.0
			%ShootingPoint.position.x = -72.0
	else:
		velocity.x = 0
		#velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	if Input.is_action_pressed(num+"shoot") and %CooldownTimer.is_stopped():
		%CooldownTimer.start()
		const BULLET: PackedScene = preload("uid://ciuw68m2kqgis")
		var bullet: Bullet = BULLET.instantiate()
		%Bullets.add_child(bullet)
		bullet.global_position = %ShootingPoint.global_position
		bullet.dir = 1 if %Nose.position.x > 0 else -1
		bullet.modulate = modulate
	
	
	move_and_slide()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is Bullet:
		area.queue_free()
		health -= 10
		%HealthLabel.text = "HP: " + str(health)
		if health <= 0:
			get_parent().i_died.emit(num)
			queue_free()
