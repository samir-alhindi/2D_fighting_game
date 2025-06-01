extends Node

signal i_died(who: String)

func _ready() -> void:
	%WonLabel.hide()
	i_died.connect(
		func(who: String) -> void:
			if who == "p1_":
				%WonLabel.text = "Blue wins !!!"
				%WonLabel.modulate = Color(0.0, 0.0, 255.0)
			elif who == "p2_":
				%WonLabel.text = "Red wins !!!"
				%WonLabel.modulate = Color(255.0, 0.0, 0.0)
			%WonLabel.show()
			await get_tree().create_timer(3).timeout
			get_tree().reload_current_scene()
	)
