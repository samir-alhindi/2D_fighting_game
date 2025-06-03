extends CharacterBody2D

@export_enum("p1_", "p2_") var num: String = "p1_"
@export var color: Color

var speed: float = 500.0
var jump_force: float = -900.0
var accel = 900
var friction = 1000

var was_in_air: bool = false

var health: int = 100

func _ready() -> void:
	%Sprite.color = color
	%Nose.color = color

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
	
	if is_on_floor() and was_in_air:
		was_in_air = false
		%Anim.play("land")
		%LandJump.play()
	
	if is_on_floor() and velocity.x != 0:
		%WalkingParticles.emitting = true
	else:
		%WalkingParticles.emitting = false
	
	# Handle jump.
	if Input.is_action_just_pressed(num + "jump") and is_on_floor():
		velocity.y = jump_force
		%Anim.play("jump")
		%JumpSound.play()
	
	
	# movement:
	var dir: float = Input.get_axis(num+"left", num+"right")
	if dir != 0:
		#velocity.x = speed * dir
		velocity.x = move_toward(velocity.x, speed * dir, accel * delta)
		if dir > 0:
			%Nose.position.x = 90.0
			%ShootingPoint.position.x = 110.0
			%WalkingParticles.position.x = 97.0
			%WalkingParticles.gravity.x = -20.0
		elif dir < 0:
			%Nose.position.x = -30.0
			%ShootingPoint.position.x = -72.0
			%WalkingParticles.position.x = -13.0
			%WalkingParticles.gravity.x = 20.0
	else:
		#velocity.x = 0
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	if Input.is_action_pressed(num+"shoot") and %CooldownTimer.is_stopped():
		%ShootSound.play()
		%CooldownTimer.start()
		const BULLET: PackedScene = preload("uid://ciuw68m2kqgis")
		var bullet: Bullet = BULLET.instantiate()
		%Bullets.add_child(bullet)
		bullet.global_position = %ShootingPoint.global_position
		bullet.dir = 1 if %Nose.position.x > 0 else -1
		bullet.modulate = color
	
	
	move_and_slide()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is Bullet:
		const HURT_PARTICLE: PackedScene = preload("res://hurt_particle.tscn")
		var instance: CPUParticles2D = HURT_PARTICLE.instantiate()
		instance.global_position = area.global_position
		instance.color = color
		%Particles.add_child(instance)
		%Anim.play("hurt")
		%HurtSound.play()
		area.queue_free()
		health -= 10
		%HealthLabel.text = "HP: " + str(health)
		var dir: int = area.dir
		var knockback_force := 250 * dir
		velocity.x = knockback_force
		if health <= 0:
			get_parent().i_died.emit(num)
			queue_free()
