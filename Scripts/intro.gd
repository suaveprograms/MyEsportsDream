extends Node2D


func _ready() -> void:
	$AnimationPlayer.play("Fade In")
	await get_tree().create_timer(2).timeout
	# after waiting 6 seconds, do next step
	$AnimationPlayer.play("Fade Out")  # example: play fade out animation
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
