extends Node

signal i_died(who: String, pos: Vector2)

func _ready() -> void:
	%WonLabel.hide()
	i_died.connect(
		func(who: String, pos: Vector2) -> void:
			const DEATH_PARTICLE: PackedScene = preload("uid://cvsoixker4k6d")
			var instance: CPUParticles2D = DEATH_PARTICLE.instantiate()
			instance.global_position = pos
			add_child(instance)
			%DeathSound.play()
			if who == "p1_":
				%WonLabel.text = "Blue wins !"
				%WonLabel.modulate = Color(0.0, 0.0, 255.0)
				instance.color = Color(0.0, 0.0, 255.0)
			elif who == "p2_":
				%WonLabel.text = "Red wins !"
				%WonLabel.modulate = Color(255.0, 0.0, 0.0)
				instance.color = Color(255.0, 0.0, 0.0)
			%WonLabel.show()
			await get_tree().create_timer(3).timeout
			get_tree().reload_current_scene()
	)
