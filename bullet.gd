class_name Bullet extends Area2D

var speed: int = 900
## Left or right.
var dir: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += speed * delta * dir


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()                
