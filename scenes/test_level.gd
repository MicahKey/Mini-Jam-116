extends Node2D


func _ready() -> void:
	%GameOver.visible = false


func _physics_process(delta: float) -> void:
	if Global.Player.HP <= 0:
		await get_tree().create_timer(2).timeout
		%GameOver.visible = true
		get_tree().paused = true
