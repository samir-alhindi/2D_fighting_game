extends Area2D

var speed: int = 900
## Left or right.
var dir: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += speed * delta * dir
