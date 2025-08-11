extends Node2D








func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/character_menu.tscn")


func _on_load_pressed() -> void:
	if FileAccess.file_exists("user://savegame.dat"):
		SaveManager.load_game()
		TeamDatabase.load_from_file()
		TeamDatabase.load_tournament_history_from_file()
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	else:
		print("❌ No save file found.")


func _on_quit_pressed() -> void:
	get_tree().quit()
