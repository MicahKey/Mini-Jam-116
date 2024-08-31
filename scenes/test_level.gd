extends Node2D


func _ready() -> void:
	%GameOver.visible = false

func update_ui():
	if Global.Player.HP == 3:
		$UI/HBoxContainer/Heart_3.visible = true
		$UI/HBoxContainer/Heart_2.visible = true
		$UI/HBoxContainer/Heart_1.visible = true
		
	elif Global.Player.HP == 2:
		$UI/HBoxContainer/Heart_3.visible = false
		$UI/HBoxContainer/Heart_2.visible = true
		$UI/HBoxContainer/Heart_1.visible = true
	
	elif Global.Player.HP == 1:
		$UI/HBoxContainer/Heart_3.visible = false
		$UI/HBoxContainer/Heart_2.visible = false
		$UI/HBoxContainer/Heart_1.visible = true
	
	elif Global.Player.HP == 0:
		$UI/HBoxContainer/Heart_3.visible = false
		$UI/HBoxContainer/Heart_2.visible = false
		$UI/HBoxContainer/Heart_1.visible = false

func _physics_process(delta: float) -> void:
	if Global.Player:
		update_ui()
	
	if Global.Player.HP <= 0:
		await get_tree().create_timer(2).timeout
		%GameOver.visible = true
		get_tree().paused = true
