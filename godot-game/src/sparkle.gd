extends Sprite2D
@onready var animPlayer = $AnimationPlayer

#func _ready():
	#playSparkle1()
	
func playSparkle1():
	print("play sparkle 1")
	animPlayer.play("sparkle1")
	
func playSparkle2():
	animPlayer.play("sparkle2")
	
func playSparkle3():
	animPlayer.play("sparkle3")
